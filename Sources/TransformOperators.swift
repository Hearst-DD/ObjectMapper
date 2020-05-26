//
//  TransformOperators.swift
//  ObjectMapper
//
//  Created by Tristan Himmelman on 2016-09-26.
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

// MARK:- Transforms

/// Object of Basic type with Transform
public func <- <Transform: TransformType>(left: inout Transform.Object, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .fromJSON where map.isKeyPresent:
		let value = transform.transformFromJSON(map.currentValue)
		FromJSON.basicType(&left, object: value)
	case .toJSON:
		left >>> right
	default: ()
	}
}

public func >>> <Transform: TransformType>(left: Transform.Object, right: (Map, Transform)) {
	let (map, transform) = right
	if map.mappingType == .toJSON {
		let value: Transform.JSON? = transform.transformToJSON(left)
		ToJSON.optionalBasicType(value, map: map)
	}
}


/// Optional object of basic type with Transform
public func <- <Transform: TransformType>(left: inout Transform.Object?, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .fromJSON where map.isKeyPresent:
		let value = transform.transformFromJSON(map.currentValue)
		FromJSON.optionalBasicType(&left, object: value)
	case .toJSON:
		left >>> right
	default: ()
	}
}

public func >>> <Transform: TransformType>(left: Transform.Object?, right: (Map, Transform)) {
	let (map, transform) = right
	if map.mappingType == .toJSON {
		let value: Transform.JSON? = transform.transformToJSON(left)
		ToJSON.optionalBasicType(value, map: map)
	}
}


// Code targeting the Swift 4.1 compiler and below.
#if !(swift(>=4.1.50) || (swift(>=3.4) && !swift(>=4.0)))
/// Implicitly unwrapped optional object of basic type with Transform
public func <- <Transform: TransformType>(left: inout Transform.Object!, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .fromJSON where map.isKeyPresent:
		let value = transform.transformFromJSON(map.currentValue)
		FromJSON.optionalBasicType(&left, object: value)
	case .toJSON:
		left >>> right
	default: ()
	}
}
#endif

/// Array of Basic type with Transform
public func <- <Transform: TransformType>(left: inout [Transform.Object], right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .fromJSON where map.isKeyPresent:
		let values = fromJSONArrayWithTransform(map.currentValue, transform: transform)
		FromJSON.basicType(&left, object: values)
	case .toJSON:
		left >>> right
	default: ()
	}
}

public func >>> <Transform: TransformType>(left: [Transform.Object], right: (Map, Transform)) {
	let (map, transform) = right
	if map.mappingType == .toJSON{
		let values = toJSONArrayWithTransform(left, transform: transform)
		ToJSON.optionalBasicType(values, map: map)
	}
}


/// Optional array of Basic type with Transform
public func <- <Transform: TransformType>(left: inout [Transform.Object]?, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .fromJSON where map.isKeyPresent:
		let values = fromJSONArrayWithTransform(map.currentValue, transform: transform)
		FromJSON.optionalBasicType(&left, object: values)
	case .toJSON:
		left >>> right
	default: ()
	}
}

public func >>> <Transform: TransformType>(left: [Transform.Object]?, right: (Map, Transform)) {
	let (map, transform) = right
	if map.mappingType == .toJSON {
		let values = toJSONArrayWithTransform(left, transform: transform)
		ToJSON.optionalBasicType(values, map: map)
	}
}


// Code targeting the Swift 4.1 compiler and below.
#if !(swift(>=4.1.50) || (swift(>=3.4) && !swift(>=4.0)))
/// Implicitly unwrapped optional array of Basic type with Transform
public func <- <Transform: TransformType>(left: inout [Transform.Object]!, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .fromJSON where map.isKeyPresent:
		let values = fromJSONArrayWithTransform(map.currentValue, transform: transform)
		FromJSON.optionalBasicType(&left, object: values)
	case .toJSON:
		left >>> right
	default: ()
	}
}
#endif

/// Dictionary of Basic type with Transform
public func <- <Transform: TransformType>(left: inout [String: Transform.Object], right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .fromJSON where map.isKeyPresent:
		let values = fromJSONDictionaryWithTransform(map.currentValue, transform: transform)
		FromJSON.basicType(&left, object: values)
	case .toJSON:
		left >>> right
	default: ()
	}
}

public func >>> <Transform: TransformType>(left: [String: Transform.Object], right: (Map, Transform)) {
	let (map, transform) = right
	if map.mappingType == . toJSON {
		let values = toJSONDictionaryWithTransform(left, transform: transform)
		ToJSON.optionalBasicType(values, map: map)
	}
}


/// Optional dictionary of Basic type with Transform
public func <- <Transform: TransformType>(left: inout [String: Transform.Object]?, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .fromJSON where map.isKeyPresent:
		let values = fromJSONDictionaryWithTransform(map.currentValue, transform: transform)
		FromJSON.optionalBasicType(&left, object: values)
	case .toJSON:
		left >>> right
	default: ()
	}
}

public func >>> <Transform: TransformType>(left: [String: Transform.Object]?, right: (Map, Transform)) {
	let (map, transform) = right
	if map.mappingType == .toJSON {
		let values = toJSONDictionaryWithTransform(left, transform: transform)
		ToJSON.optionalBasicType(values, map: map)
	}
}


// Code targeting the Swift 4.1 compiler and below.
#if !(swift(>=4.1.50) || (swift(>=3.4) && !swift(>=4.0)))
/// Implicitly unwrapped optional dictionary of Basic type with Transform
public func <- <Transform: TransformType>(left: inout [String: Transform.Object]!, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .fromJSON where map.isKeyPresent:
		let values = fromJSONDictionaryWithTransform(map.currentValue, transform: transform)
		FromJSON.optionalBasicType(&left, object: values)
	case .toJSON:
		left >>> right
	default: ()
	}
}
#endif

// MARK:- Transforms of Mappable Objects - <T: BaseMappable>

/// Object conforming to Mappable that have transforms
public func <- <Transform: TransformType>(left: inout Transform.Object, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	switch map.mappingType {
	case .fromJSON where map.isKeyPresent:
		let value: Transform.Object? = transform.transformFromJSON(map.currentValue)
		FromJSON.basicType(&left, object: value)
	case .toJSON:
		left >>> right
	default: ()
	}
}

public func >>> <Transform: TransformType>(left: Transform.Object, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	if map.mappingType == .toJSON {
		let value: Transform.JSON? = transform.transformToJSON(left)
		ToJSON.optionalBasicType(value, map: map)
	}
}


/// Optional Mappable objects that have transforms
public func <- <Transform: TransformType>(left: inout Transform.Object?, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	switch map.mappingType {
	case .fromJSON where map.isKeyPresent:
		let value: Transform.Object? = transform.transformFromJSON(map.currentValue)
		FromJSON.optionalBasicType(&left, object: value)
	case .toJSON:
		left >>> right
	default: ()
	}
}

public func >>> <Transform: TransformType>(left: Transform.Object?, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	if map.mappingType == .toJSON{
		let value: Transform.JSON? = transform.transformToJSON(left)
		ToJSON.optionalBasicType(value, map: map)
	}
}


// Code targeting the Swift 4.1 compiler and below.
#if !(swift(>=4.1.50) || (swift(>=3.4) && !swift(>=4.0)))
/// Implicitly unwrapped optional Mappable objects that have transforms
public func <- <Transform: TransformType>(left: inout Transform.Object!, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	switch map.mappingType {
	case .fromJSON where map.isKeyPresent:
		let value: Transform.Object? = transform.transformFromJSON(map.currentValue)
		FromJSON.optionalBasicType(&left, object: value)
	case .toJSON:
		left >>> right
	default: ()
	}
}
#endif


// MARK:- Dictionary of Mappable objects with a transform - Dictionary<String, T: BaseMappable>

/// Dictionary of Mappable objects <String, T: Mappable> with a transform
public func <- <Transform: TransformType>(left: inout Dictionary<String, Transform.Object>, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	if map.mappingType == .fromJSON && map.isKeyPresent,
		let object = map.currentValue as? [String: Any] {
		let value = fromJSONDictionaryWithTransform(object as Any?, transform: transform) ?? left
		FromJSON.basicType(&left, object: value)
	} else if map.mappingType == .toJSON {
		left >>> right
	}
}

public func >>> <Transform: TransformType>(left: Dictionary<String, Transform.Object>, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	if map.mappingType == .toJSON {
		let value = toJSONDictionaryWithTransform(left, transform: transform)
		ToJSON.basicType(value, map: map)
	}
}


/// Optional Dictionary of Mappable object <String, T: Mappable> with a transform
public func <- <Transform: TransformType>(left: inout Dictionary<String, Transform.Object>?, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	if map.mappingType == .fromJSON && map.isKeyPresent, let object = map.currentValue as? [String : Any]{
		let value = fromJSONDictionaryWithTransform(object as Any?, transform: transform) ?? left
		FromJSON.optionalBasicType(&left, object: value)
	} else if map.mappingType == .toJSON {
		left >>> right
	}
}

public func >>> <Transform: TransformType>(left: Dictionary<String, Transform.Object>?, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	if map.mappingType == .toJSON {
		let value = toJSONDictionaryWithTransform(left, transform: transform)
		ToJSON.optionalBasicType(value, map: map)
	}
}


// Code targeting the Swift 4.1 compiler and below.
#if !(swift(>=4.1.50) || (swift(>=3.4) && !swift(>=4.0)))
/// Implicitly unwrapped Optional Dictionary of Mappable object <String, T: Mappable> with a transform
public func <- <Transform: TransformType>(left: inout Dictionary<String, Transform.Object>!, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	if map.mappingType == .fromJSON && map.isKeyPresent, let dictionary = map.currentValue as? [String : Any]{
		let transformedDictionary = fromJSONDictionaryWithTransform(dictionary as Any?, transform: transform) ?? left
		FromJSON.optionalBasicType(&left, object: transformedDictionary)
	} else if map.mappingType == .toJSON {
		left >>> right
	}
}
#endif

/// Dictionary of Mappable objects <String, T: Mappable> with a transform
public func <- <Transform: TransformType>(left: inout Dictionary<String, [Transform.Object]>, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	
	if let dictionary = map.currentValue as? [String : [Any]], map.mappingType == .fromJSON && map.isKeyPresent {
		let transformedDictionary = dictionary.map { (arg: (key: String, values: [Any])) -> (String, [Transform.Object]) in
			let (key, values) = arg
			if let jsonArray = fromJSONArrayWithTransform(values, transform: transform) {
				return (key, jsonArray)
			}
			if let leftValue = left[key] {
				return (key, leftValue)
			}
			return (key, [])
		}
		
		FromJSON.basicType(&left, object: transformedDictionary)
	} else if map.mappingType == .toJSON {
		left >>> right
	}
}

public func >>> <Transform: TransformType>(left: Dictionary<String, [Transform.Object]>, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	
	if map.mappingType == .toJSON {
		
		let transformedDictionary = left.map { (arg: (key: String, value: [Transform.Object])) in
			return (arg.key, toJSONArrayWithTransform(arg.value, transform: transform) ?? [])
		}
		
		ToJSON.basicType(transformedDictionary, map: map)
	}
}


/// Optional Dictionary of Mappable object <String, T: Mappable> with a transform
public func <- <Transform: TransformType>(left: inout Dictionary<String, [Transform.Object]>?, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	
	if let dictionary = map.currentValue as? [String : [Any]], map.mappingType == .fromJSON && map.isKeyPresent {
		
		let transformedDictionary = dictionary.map { (arg: (key: String, values: [Any])) -> (String, [Transform.Object]) in
			let (key, values) = arg
			if let jsonArray = fromJSONArrayWithTransform(values, transform: transform) {
				return (key, jsonArray)
			}
			if let leftValue = left?[key] {
				return (key, leftValue)
			}
			return (key, [])
		}
		
		FromJSON.optionalBasicType(&left, object: transformedDictionary)
	} else if map.mappingType == .toJSON {
		left >>> right
	}
}

public func >>> <Transform: TransformType>(left: Dictionary<String, [Transform.Object]>?, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	
	if map.mappingType == .toJSON {
		let transformedDictionary = left?.map { (arg: (key: String, values: [Transform.Object])) in
			return (arg.key, toJSONArrayWithTransform(arg.values, transform: transform) ?? [])
		}
		
		ToJSON.optionalBasicType(transformedDictionary, map: map)
	}
}


// Code targeting the Swift 4.1 compiler and below.
#if !(swift(>=4.1.50) || (swift(>=3.4) && !swift(>=4.0)))
/// Implicitly unwrapped Optional Dictionary of Mappable object <String, T: Mappable> with a transform
public func <- <Transform: TransformType>(left: inout Dictionary<String, [Transform.Object]>!, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	
	if let dictionary = map.currentValue as? [String : [Any]], map.mappingType == .fromJSON && map.isKeyPresent {
		let transformedDictionary = dictionary.map { (arg: (key: String, values: [Any])) -> (String, [Transform.Object]) in
			let (key, values) = arg
			if let jsonArray = fromJSONArrayWithTransform(values, transform: transform) {
				return (key, jsonArray)
			}
			if let leftValue = left?[key] {
				return (key, leftValue)
			}
			return (key, [])
		}
		FromJSON.optionalBasicType(&left, object: transformedDictionary)
	} else if map.mappingType == .toJSON {
		left >>> right
	}
}
#endif

// MARK:- Array of Mappable objects with transforms - Array<T: BaseMappable>

/// Array of Mappable objects
public func <- <Transform: TransformType>(left: inout Array<Transform.Object>, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	switch map.mappingType {
	case .fromJSON where map.isKeyPresent:
		if let transformedValues = fromJSONArrayWithTransform(map.currentValue, transform: transform) {
			FromJSON.basicType(&left, object: transformedValues)
		}
	case .toJSON:
		left >>> right
	default: ()
	}
}

public func >>> <Transform: TransformType>(left: Array<Transform.Object>, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	if map.mappingType == .toJSON {
		let transformedValues = toJSONArrayWithTransform(left, transform: transform)
		ToJSON.optionalBasicType(transformedValues, map: map)
	}
}


/// Optional array of Mappable objects
public func <- <Transform: TransformType>(left: inout Array<Transform.Object>?, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	switch map.mappingType {
	case .fromJSON where map.isKeyPresent:
		let transformedValues = fromJSONArrayWithTransform(map.currentValue, transform: transform)
		FromJSON.optionalBasicType(&left, object: transformedValues)
	case .toJSON:
		left >>> right
	default: ()
	}
}

public func >>> <Transform: TransformType>(left: Array<Transform.Object>?, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	if map.mappingType == .toJSON {
		let transformedValues = toJSONArrayWithTransform(left, transform: transform)
		ToJSON.optionalBasicType(transformedValues, map: map)
	}
}


// Code targeting the Swift 4.1 compiler and below.
#if !(swift(>=4.1.50) || (swift(>=3.4) && !swift(>=4.0)))
/// Implicitly unwrapped Optional array of Mappable objects
public func <- <Transform: TransformType>(left: inout Array<Transform.Object>!, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	switch map.mappingType {
	case .fromJSON where map.isKeyPresent:
		let transformedValues = fromJSONArrayWithTransform(map.currentValue, transform: transform)
		FromJSON.optionalBasicType(&left, object: transformedValues)
	case .toJSON:
		left >>> right
	default: ()
	}
}
#endif

// MARK:- Array of Array of objects - Array<Array<T>>> with transforms

/// Array of Array of objects with transform
public func <- <Transform: TransformType>(left: inout [[Transform.Object]], right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .toJSON:
		left >>> right
	case .fromJSON where map.isKeyPresent:
		guard let original2DArray = map.currentValue as? [[Any]] else { break }
		#if swift(>=4.1)
		let transformed2DArray = original2DArray.compactMap { values in
			fromJSONArrayWithTransform(values as Any?, transform: transform)
		}
		#else
		let transformed2DArray = original2DArray.compactMap { values in
			fromJSONArrayWithTransform(values as Any?, transform: transform)
		}
		#endif
		FromJSON.basicType(&left, object: transformed2DArray)
	default:
		break
	}
}

public func >>> <Transform: TransformType>(left: [[Transform.Object]], right: (Map, Transform)) {
	let (map, transform) = right
	if map.mappingType == .toJSON{
		#if swift(>=4.1)
		let transformed2DArray = left.compactMap { values in
			toJSONArrayWithTransform(values, transform: transform)
		}
		#else
		let transformed2DArray = left.compactMap { values in
			toJSONArrayWithTransform(values, transform: transform)
		}
		#endif
		ToJSON.basicType(transformed2DArray, map: map)
	}
}

/// Optional array of array of objects with transform
public func <- <Transform: TransformType>(left: inout [[Transform.Object]]?, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .toJSON:
		left >>> right
	case .fromJSON where map.isKeyPresent:
		guard let original2DArray = map.currentValue as? [[Any]] else { break }
		#if swift(>=4.1)
		let transformed2DArray = original2DArray.compactMap { values in
			fromJSONArrayWithTransform(values as Any?, transform: transform)
		}
		#else
		let transformed2DArray = original2DArray.compactMap { values in
			fromJSONArrayWithTransform(values as Any?, transform: transform)
		}
		#endif
		FromJSON.optionalBasicType(&left, object: transformed2DArray)
	default:
		break
	}
}

public func >>> <Transform: TransformType>(left: [[Transform.Object]]?, right: (Map, Transform)) {
	let (map, transform) = right
	if map.mappingType == .toJSON {
		#if swift(>=4.1)
		let transformed2DArray = left?.compactMap { values in
			toJSONArrayWithTransform(values, transform: transform)
		}
		#else
		let transformed2DArray = left?.compactMap { values in
			toJSONArrayWithTransform(values, transform: transform)
		}
		#endif
		ToJSON.optionalBasicType(transformed2DArray, map: map)
	}
}


// Code targeting the Swift 4.1 compiler and below.
#if !(swift(>=4.1.50) || (swift(>=3.4) && !swift(>=4.0)))
/// Implicitly unwrapped Optional array of array of objects with transform
public func <- <Transform: TransformType>(left: inout [[Transform.Object]]!, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .toJSON:
		left >>> right
	case .fromJSON where map.isKeyPresent:
		guard let original2DArray = map.currentValue as? [[Any]] else { break }
		#if swift(>=4.1)
		let transformed2DArray = original2DArray.compactMap { values in
			fromJSONArrayWithTransform(values as Any?, transform: transform)
		}
		#else
		let transformed2DArray = original2DArray.flatMap { values in
			fromJSONArrayWithTransform(values as Any?, transform: transform)
		}
		#endif
		FromJSON.optionalBasicType(&left, object: transformed2DArray)
	default:
		break
	}
}
#endif

// MARK:- Set of Mappable objects with a transform - Set<T: BaseMappable>

/// Set of Mappable objects with transform
public func <- <Transform: TransformType>(left: inout Set<Transform.Object>, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	switch map.mappingType {
	case .fromJSON where map.isKeyPresent:
		if let transformedValues = fromJSONArrayWithTransform(map.currentValue, transform: transform) {
			FromJSON.basicType(&left, object: Set(transformedValues))
		}
	case .toJSON:
		left >>> right
	default: ()
	}
}

public func >>> <Transform: TransformType>(left: Set<Transform.Object>, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	if map.mappingType == .toJSON {
		let transformedValues = toJSONArrayWithTransform(Array(left), transform: transform)
		ToJSON.optionalBasicType(transformedValues, map: map)
	}
}


/// Optional Set of Mappable objects with transform
public func <- <Transform: TransformType>(left: inout Set<Transform.Object>?, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	switch map.mappingType {
	case .fromJSON where map.isKeyPresent:
		if let transformedValues = fromJSONArrayWithTransform(map.currentValue, transform: transform) {
			FromJSON.basicType(&left, object: Set(transformedValues))
		}
	case .toJSON:
		left >>> right
	default: ()
	}
}

public func >>> <Transform: TransformType>(left: Set<Transform.Object>?, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	if map.mappingType == .toJSON {
		if let values = left {
			let transformedValues = toJSONArrayWithTransform(Array(values), transform: transform)
			ToJSON.optionalBasicType(transformedValues, map: map)
		}
	}
}


// Code targeting the Swift 4.1 compiler and below.
#if !(swift(>=4.1.50) || (swift(>=3.4) && !swift(>=4.0)))
/// Implicitly unwrapped Optional set of Mappable objects with transform
public func <- <Transform: TransformType>(left: inout Set<Transform.Object>!, right: (Map, Transform)) where Transform.Object: BaseMappable {
	let (map, transform) = right
	switch map.mappingType {
	case .fromJSON where map.isKeyPresent:
		if let transformedValues = fromJSONArrayWithTransform(map.currentValue, transform: transform) {
			FromJSON.basicType(&left, object: Set(transformedValues))
		}
	case .toJSON:
		left >>> right
	default: ()
	}
}
#endif


private func fromJSONArrayWithTransform<Transform: TransformType>(_ input: Any?, transform: Transform) -> [Transform.Object]? {
	if let values = input as? [Any] {
		#if swift(>=4.1)
		return values.compactMap { value in
			return transform.transformFromJSON(value)
		}
		#else
		return values.compactMap { value in
			return transform.transformFromJSON(value)
		}
		#endif
	} else {
		return nil
	}
}

private func fromJSONDictionaryWithTransform<Transform: TransformType>(_ input: Any?, transform: Transform) -> [String: Transform.Object]? {
	if let values = input as? [String: Any] {
		return values.filterMap { value in
			return transform.transformFromJSON(value)
		}
	} else {
		return nil
	}
}

private func toJSONArrayWithTransform<Transform: TransformType>(_ input: [Transform.Object]?, transform: Transform) -> [Transform.JSON]? {
	#if swift(>=4.1)
	return input?.compactMap { value in
		return transform.transformToJSON(value)
	}
	#else
	return input?.compactMap { value in
		return transform.transformToJSON(value)
	}
	#endif
}

private func toJSONDictionaryWithTransform<Transform: TransformType>(_ input: [String: Transform.Object]?, transform: Transform) -> [String: Transform.JSON]? {
	return input?.filterMap { value in
		return transform.transformToJSON(value)
	}
}
