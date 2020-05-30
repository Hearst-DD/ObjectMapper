//
//  Mapper.swift
//  ObjectMapper
//
//  Created by Tristan Himmelman on 2014-10-09.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014-2018 Tristan Himmelman
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

public enum MappingType {
	case fromJSON
	case toJSON
}

/// The Mapper class provides methods for converting Model objects to JSON and methods for converting JSON to Model objects
public final class Mapper<N: BaseMappable> {
	
	public var context: MapContext?
	public var shouldIncludeNilValues = false /// If this is set to true, toJSON output will include null values for any variables that are not set.
	
	public init(context: MapContext? = nil, shouldIncludeNilValues: Bool = false){
		self.context = context
		self.shouldIncludeNilValues = shouldIncludeNilValues
	}
	
	// MARK: Mapping functions that map to an existing object toObject
	
	/// Maps a JSON object to an existing Mappable object if it is a JSON dictionary, or returns the passed object as is
	public func map(JSONObject: Any?, toObject object: N) -> N {
		if let JSON = JSONObject as? [String: Any] {
			return map(JSON: JSON, toObject: object)
		}
		
		return object
	}
	
	/// Map a JSON string onto an existing object
	public func map(JSONString: String, toObject object: N) -> N {
		if let JSON = MapperParse.toJSONDictionary(JSONString: JSONString) {
			return map(JSON: JSON, toObject: object)
		}
		return object
	}
	
	/// Maps a JSON dictionary to an existing object that conforms to Mappable.
	/// Usefull for those pesky objects that have crappy designated initializers like NSManagedObject
	public func map(JSON: [String: Any], toObject object: N) -> N {
		var mutableObject = object
		let map = Map(mappingType: .fromJSON, JSON: JSON, toObject: true, context: context, shouldIncludeNilValues: shouldIncludeNilValues)
		mutableObject.mapping(map: map)
		return mutableObject
	}

	//MARK: Mapping functions that create an object
	
	/// Map a JSON string to an object that conforms to Mappable
	public func map(JSONString: String) -> N? {
		if let JSON = MapperParse.toJSONDictionary(JSONString: JSONString) {
			return map(JSON: JSON)
		}
		
		return nil
	}
	
	/// Maps a JSON object to a Mappable object if it is a JSON dictionary or NSString, or returns nil.
	public func map(JSONObject: Any?) -> N? {
		if let JSON = JSONObject as? [String: Any] {
			return map(JSON: JSON)
		}

		return nil
	}

	/// Maps a JSON dictionary to an object that conforms to Mappable
	public func map(JSON: [String: Any]) -> N? {
		let map = Map(mappingType: .fromJSON, JSON: JSON, context: context, shouldIncludeNilValues: shouldIncludeNilValues)
		
		if let klass = N.self as? StaticMappable.Type { // Check if object is StaticMappable
			if var object = klass.objectForMapping(map: map) as? N {
				object.mapping(map: map)
				return object
			}
		} else if let klass = N.self as? Mappable.Type { // Check if object is Mappable
			if var object = klass.init(map: map) as? N {
				object.mapping(map: map)
				return object
			}
		} else if let klass = N.self as? ImmutableMappable.Type { // Check if object is ImmutableMappable
			do {
				if var object = try klass.init(map: map) as? N {
					object.mapping(map: map)
					return object
				}
			} catch let error {
				#if DEBUG
				#if !os(Linux)
				let exception: NSException
				if let mapError = error as? MapError {
					exception = NSException(name: .init(rawValue: "MapError"), reason: mapError.description, userInfo: nil)
				} else {
					exception = NSException(name: .init(rawValue: "ImmutableMappableError"), reason: error.localizedDescription, userInfo: nil)
				}
				exception.raise()
				#endif
				#endif
			}
		} else {
			// Ensure BaseMappable is not implemented directly
			assert(false, "BaseMappable should not be implemented directly. Please implement Mappable, StaticMappable or ImmutableMappable")
		}
		
		return nil
	}

	// MARK: Mapping functions for Arrays and Dictionaries
	
	/// Maps a JSON array to an object that conforms to Mappable
	public func mapArray(JSONString: String) -> [N]? {
		let parsedJSON: Any? = MapperParse.toJSONObject(JSONString: JSONString)

		if let objectArray = mapArray(JSONObject: parsedJSON) {
			return objectArray
		}

		// failed to parse JSON into array form
		// try to parse it into a dictionary and then wrap it in an array
		if let object = map(JSONObject: parsedJSON) {
			return [object]
		}

		return nil
	}
	
	/// Maps a JSON object to an array of Mappable objects if it is an array of JSON dictionary, or returns nil.
	public func mapArray(JSONObject: Any?) -> [N]? {
		if let JSONArray = JSONObject as? [[String: Any]] {
			return mapArray(JSONArray: JSONArray)
		}

		return nil
	}
	
	/// Maps an array of JSON dictionary to an array of Mappable objects
	public func mapArray(JSONArray: [[String: Any]]) -> [N] {
		// map every element in JSON array to type N
		#if swift(>=4.1)
		let result = JSONArray.compactMap(map)
		#else
		let result = JSONArray.flatMap(map)
		#endif
		return result
	}
	
	/// Maps a JSON object to a dictionary of Mappable objects if it is a JSON dictionary of dictionaries, or returns nil.
	public func mapDictionary(JSONString: String) -> [String: N]? {
		let parsedJSON: Any? = MapperParse.toJSONObject(JSONString: JSONString)
		return mapDictionary(JSONObject: parsedJSON)
	}
	
	/// Maps a JSON object to a dictionary of Mappable objects if it is a JSON dictionary of dictionaries, or returns nil.
	public func mapDictionary(JSONObject: Any?) -> [String: N]? {
		if let JSON = JSONObject as? [String: [String: Any]] {
			return mapDictionary(JSON: JSON)
		}

		return nil
	}

	/// Maps a JSON dictionary of dictionaries to a dictionary of Mappable objects
	public func mapDictionary(JSON: [String: [String: Any]]) -> [String: N]? {
		// map every value in dictionary to type N
		let result = JSON.filterMap(map)
		if !result.isEmpty {
			return result
		}
		
		return nil
	}
	
	/// Maps a JSON object to a dictionary of Mappable objects if it is a JSON dictionary of dictionaries, or returns nil.
	public func mapDictionary(JSONObject: Any?, toDictionary dictionary: [String: N]) -> [String: N] {
		if let JSON = JSONObject as? [String : [String : Any]] {
			return mapDictionary(JSON: JSON, toDictionary: dictionary)
		}
		
		return dictionary
	}
	
    /// Maps a JSON dictionary of dictionaries to an existing dictionary of Mappable objects
    public func mapDictionary(JSON: [String: [String: Any]], toDictionary dictionary: [String: N]) -> [String: N] {
		var mutableDictionary = dictionary
        for (key, value) in JSON {
            if let object = dictionary[key] {
				_ = map(JSON: value, toObject: object)
            } else {
				mutableDictionary[key] = map(JSON: value)
            }
        }
        
        return mutableDictionary
    }
	
	/// Maps a JSON object to a dictionary of arrays of Mappable objects
	public func mapDictionaryOfArrays(JSONObject: Any?) -> [String: [N]]? {
		if let JSON = JSONObject as? [String: [[String: Any]]] {
			return mapDictionaryOfArrays(JSON: JSON)
		}
		
		return nil
	}
	
	///Maps a JSON dictionary of arrays to a dictionary of arrays of Mappable objects
	public func mapDictionaryOfArrays(JSON: [String: [[String: Any]]]) -> [String: [N]]? {
		// map every value in dictionary to type N
		let result = JSON.filterMap {
			mapArray(JSONArray: $0)
        }
        
		if !result.isEmpty {
			return result
		}
        
		return nil
	}
	
	/// Maps an 2 dimentional array of JSON dictionaries to a 2 dimentional array of Mappable objects
	public func mapArrayOfArrays(JSONObject: Any?) -> [[N]]? {
		if let JSONArray = JSONObject as? [[[String: Any]]] {
			let objectArray = JSONArray.map { innerJSONArray in
				return mapArray(JSONArray: innerJSONArray)
			}
			
			if !objectArray.isEmpty {
				return objectArray
			}
		}
		
		return nil
	}

	// MARK: Utility functions for converting strings to JSON objects
	
	/// Convert a JSON String into a Dictionary<String, Any> using NSJSONSerialization
	@available(*, deprecated, message:"Use MapperParse")
	public static func parseJSONStringIntoDictionary(JSONString: String) -> [String: Any]? {
		let parsedJSON: Any? = Mapper.parseJSONString(JSONString: JSONString)
		return parsedJSON as? [String: Any]
	}

	/// Convert a JSON String into an Object using NSJSONSerialization
	@available(*, deprecated, message:"Use MapperParse")
	public static func parseJSONString(JSONString: String) -> Any? {
		let data = JSONString.data(using: String.Encoding.utf8, allowLossyConversion: true)
		if let data = data {
			let parsedJSON: Any?
			do {
				parsedJSON = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
			} catch let error {
				print(error)
				parsedJSON = nil
			}
			return parsedJSON
		}

		return nil
	}
}

extension Mapper {
	// MARK: Functions that create model from JSON file

	/// JSON file to Mappable object
	/// - parameter JSONfile: Filename
	/// - Returns: Mappable object
	public func map(JSONfile: String) -> N? {
		if let path = Bundle.main.path(forResource: JSONfile, ofType: nil) {
			do {
				let JSONString = try String(contentsOfFile: path)
				do {
					return self.map(JSONString: JSONString)
				}
			} catch {
				return nil
			}
		}
		return nil
	}

	/// JSON file to Mappable object array
	/// - parameter JSONfile: Filename
	/// - Returns: Mappable object array
	public func mapArray(JSONfile: String) -> [N]? {
		if let path = Bundle.main.path(forResource: JSONfile, ofType: nil) {
			do {
				let JSONString = try String(contentsOfFile: path)
				do {
					return self.mapArray(JSONString: JSONString)
				}
			} catch {
				return nil
			}
		}
		return nil
	}
}

extension Mapper {
    
	// MARK: Functions that create JSON from objects	
	
	///Maps an object that conforms to Mappable to a JSON dictionary <String, Any>
	public func toJSON(_ object: N) -> [String: Any] {
		var mutableObject = object
		let map = Map(mappingType: .toJSON, JSON: [:], context: context, shouldIncludeNilValues: shouldIncludeNilValues)
		mutableObject.mapping(map: map)
		return map.JSON
	}
	
	///Maps an array of Objects to an array of JSON dictionaries [[String: Any]]
	public func toJSONArray(_ array: [N]) -> [[String: Any]] {
		return array.map {
			// convert every element in array to JSON dictionary equivalent
			self.toJSON($0)
		}
	}
	
	///Maps a dictionary of Objects that conform to Mappable to a JSON dictionary of dictionaries.
	public func toJSONDictionary(_ dictionary: [String: N]) -> [String: [String: Any]] {
		return dictionary.map { (arg: (key: String, value: N)) in
			// convert every value in dictionary to its JSON dictionary equivalent
			return (arg.key, self.toJSON(arg.value))
		}
	}
	
	///Maps a dictionary of Objects that conform to Mappable to a JSON dictionary of dictionaries.
	public func toJSONDictionaryOfArrays(_ dictionary: [String: [N]]) -> [String: [[String: Any]]] {
		return dictionary.map { (arg: (key: String, value: [N])) in
			// convert every value (array) in dictionary to its JSON dictionary equivalent
			return (arg.key, self.toJSONArray(arg.value))
		}
	}
	
	/// Maps an Object to a JSON string with option of pretty formatting
	public func toJSONString(_ object: N, prettyPrint: Bool = false) -> String? {
		let JSONDict = toJSON(object)
		
        return MapperParse.toJSONString(JSONDict as Any, prettyPrint: prettyPrint)
	}

    /// Maps an array of Objects to a JSON string with option of pretty formatting	
    public func toJSONString(_ array: [N], prettyPrint: Bool = false) -> String? {
        let JSONDict = toJSONArray(array)
        
        return MapperParse.toJSONString(JSONDict as Any, prettyPrint: prettyPrint)
    }
	
	/// Converts an Object to a JSON string with option of pretty formatting
	@available(*, deprecated, message:"Use MapperParse")
	public static func toJSONString(_ JSONObject: Any, prettyPrint: Bool) -> String? {
		let options: JSONSerialization.WritingOptions = prettyPrint ? .prettyPrinted : []
		if let JSON = Mapper.toJSONData(JSONObject, options: options) {
			return String(data: JSON, encoding: String.Encoding.utf8)
		}
		
		return nil
	}
	
	/// Converts an Object to JSON data with options
	@available(*, deprecated, message:"Use MapperParse")
	public static func toJSONData(_ JSONObject: Any, options: JSONSerialization.WritingOptions) -> Data? {
		if JSONSerialization.isValidJSONObject(JSONObject) {
			let JSONData: Data?
			do {
				JSONData = try JSONSerialization.data(withJSONObject: JSONObject, options: options)
			} catch let error {
				print(error)
				JSONData = nil
			}
			
			return JSONData
		}
		
		return nil
	}
}

extension Mapper where N: Hashable {
	
	/// Maps a JSON array to an object that conforms to Mappable
	public func mapSet(JSONString: String) -> Set<N>? {
		let parsedJSON: Any? = MapperParse.toJSONObject(JSONString: JSONString)
		
		if let objectArray = mapArray(JSONObject: parsedJSON) {
			return Set(objectArray)
		}
		
		// failed to parse JSON into array form
		// try to parse it into a dictionary and then wrap it in an array
		if let object = map(JSONObject: parsedJSON) {
			return Set([object])
		}
		
		return nil
	}
	
	/// Maps a JSON object to an Set of Mappable objects if it is an array of JSON dictionary, or returns nil.
	public func mapSet(JSONObject: Any?) -> Set<N>? {
		if let JSONArray = JSONObject as? [[String: Any]] {
			return mapSet(JSONArray: JSONArray)
		}
		
		return nil
	}
	
	/// Maps an Set of JSON dictionary to an array of Mappable objects
	public func mapSet(JSONArray: [[String: Any]]) -> Set<N> {
		// map every element in JSON array to type N
		#if swift(>=4.1)
		return Set(JSONArray.compactMap(map))
		#else
		return Set(JSONArray.flatMap(map))
		#endif
	}

	///Maps a Set of Objects to a Set of JSON dictionaries [[String : Any]]
	public func toJSONSet(_ set: Set<N>) -> [[String: Any]] {
		return set.map {
			// convert every element in set to JSON dictionary equivalent
			self.toJSON($0)
		}
	}
	
	/// Maps a set of Objects to a JSON string with option of pretty formatting
	public func toJSONString(_ set: Set<N>, prettyPrint: Bool = false) -> String? {
		let JSONDict = toJSONSet(set)
		
		return MapperParse.toJSONString(JSONDict as Any, prettyPrint: prettyPrint)
	}
}

extension Dictionary {
	internal func map<K, V>(_ f: (Element) throws -> (K, V)) rethrows -> [K: V] {
		var mapped = [K: V]()

		for element in self {
			let newElement = try f(element)
			mapped[newElement.0] = newElement.1
		}

		return mapped
	}

	internal func map<K, V>(_ f: (Element) throws -> (K, [V])) rethrows -> [K: [V]] {
		var mapped = [K: [V]]()
		
		for element in self {
			let newElement = try f(element)
			mapped[newElement.0] = newElement.1
		}
		
		return mapped
	}

	
	internal func filterMap<U>(_ f: (Value) throws -> U?) rethrows -> [Key: U] {
		var mapped = [Key: U]()

		for (key, value) in self {
			if let newValue = try f(value) {
				mapped[key] = newValue
			}
		}

		return mapped
	}
}
