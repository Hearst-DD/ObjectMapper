//
//  MapperParse.swift
//  ObjectMapper-iOS
//
//  Created by yixiaojichunqiu on 2019/6/13.
//  Copyright © 2019 hearst. All rights reserved.
//

import Foundation

public final class MapperParse
{
	/// Converts an Object to a JSON string with option of pretty formatting
	public static func toJSONString(_ JSONObject: Any, prettyPrint: Bool) -> String? {
		let options: JSONSerialization.WritingOptions = prettyPrint ? .prettyPrinted : []
		if let JSON = MapperParse.toJSONData(JSONObject, options: options) {
			return String(data: JSON, encoding: String.Encoding.utf8)
		}
		
		return nil
	}
	
	/// Converts an Object to JSON data with options
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
	
	// MARK: Utility functions for converting strings to JSON objects
	
	/// Convert a JSON String into a Dictionary<String, Any> using NSJSONSerialization
	public static func toJSONDictionary(JSONString: String) -> [String: Any]? {
		let parsedJSON: Any? = MapperParse.toJSONObject(JSONString: JSONString)
		return parsedJSON as? [String: Any]
	}
	
	/// Convert a JSON String into an Object using NSJSONSerialization
	public static func toJSONObject(JSONString: String) -> Any? {
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
