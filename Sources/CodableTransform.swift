//
//  CodableTransform.swift
//  ObjectMapper
//
//  Created by Jari Kalinainen on 10/10/2018.
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

/// Transforms JSON dictionary to Codable type T and back
open class CodableTransform<T: Codable>: TransformType {

    public typealias Object = T
    public typealias JSON = Any

    public init() {}

    open func transformFromJSON(_ value: Any?) -> Object? {
		guard let item = value else {
			return nil
		}
		
		if JSONSerialization.isValidJSONObject(item) {
			guard let data = try? JSONSerialization.data(withJSONObject: item, options: []) else {
				return nil
			}
			return try? JSONDecoder().decode(T.self, from: data)
		} else {
			guard let data = try? JSONSerialization.data(withJSONObject: ["value": item], options: []) else {
				return nil
			}
			return try? JSONDecoder().decode(DecodableWrapper<T>.self, from: data).value
		}
    }

    open func transformToJSON(_ value: T?) -> JSON? {
        guard let item = value else {
            return nil
        }
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(item)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return dictionary
        } catch {
            return nil
        }
    }
}

private struct DecodableWrapper<T: Decodable>: Decodable {
    let value: T
}
