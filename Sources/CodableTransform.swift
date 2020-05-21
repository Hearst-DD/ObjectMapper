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
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    public init(decoder: JSONDecoder = .init(), encoder: JSONEncoder = .init()) {
        self.encoder = encoder
        self.decoder = decoder
    }

    open func transformFromJSON(_ value: Any?) -> Object? {
				var _data: Data? = nil
				switch value {
				case let dict as [String : Any]:
					_data = try? JSONSerialization.data(withJSONObject: dict, options: [])
				case let array as [[String : Any]]:
					_data = try? JSONSerialization.data(withJSONObject: array, options: [])
				default:
					_data = nil
				}
				guard let data = _data else { return nil }
				
        do {
            let item = try decoder.decode(T.self, from: data)
            return item
        } catch {
            return nil
        }
    }

    open func transformToJSON(_ value: T?) -> JSON? {
        guard let item = value else {
            return nil
        }
        do {
            let data = try encoder.encode(item)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return dictionary
        } catch {
            return nil
        }
    }
}
