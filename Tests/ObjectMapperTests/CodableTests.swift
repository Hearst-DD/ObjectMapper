//
//  CodableTests.swift
//  ObjectMapper
//
//  Created by Jari Kalinainen on 11.10.18.
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
import XCTest
import ObjectMapper

class CodableTests: XCTestCase {
	
	func testSingleValueCodableTransform() {
		let boolJSON = ["value": ["single_value": true]]
		let boolObject = try? Mapper<SingleMappableObject<Bool>>().map(JSON: boolJSON)
		XCTAssertEqual(true, boolObject?.value)
		
		let intJSON = ["value": ["single_value": 1]]
		let intObject = try? Mapper<SingleMappableObject<Int>>().map(JSON: intJSON)
		XCTAssertEqual(1, intObject?.value)
		
		let stringJSON = ["value": ["single_value": "hello object mapper"]]
		let stringObject = try? Mapper<SingleMappableObject<String>>().map(JSON: stringJSON)
		XCTAssertEqual("hello object mapper", stringObject?.value)
	}
	
	func testArrayValueCodableTransform() {
		let boolArrayJSON = ["value": ["array_value": [false, false, true, true]]]
		let boolArrayObject = try? Mapper<ArrayMappableObject<Bool>>().map(JSON: boolArrayJSON)
		XCTAssertEqual([false, false, true, true], boolArrayObject?.value)
		
		let intArrayJSON = ["value": ["array_value": [1, 2, 3, 4]]]
		let intArrayObject = try? Mapper<ArrayMappableObject<Int>>().map(JSON: intArrayJSON)
		XCTAssertEqual([1, 2, 3, 4], intArrayObject?.value)
		
		let stringArrayJSON = ["value": ["array_value": ["hello", "안녕", "nice to meet ypu", "만나서 반가워"]]]
		let stringArrayObject = try? Mapper<ArrayMappableObject<String>>().map(JSON: stringArrayJSON)
		XCTAssertEqual(["hello", "안녕", "nice to meet ypu", "만나서 반가워"], stringArrayObject?.value)
	}
	
	func testCodableTransform() {
		let value: [String: Any] = ["one": "1", "two": 2, "three": true]
		let json: [String: Any] = ["value": value, "array_value": [value, value]]
		
		let object = try? Mapper<MappableObject>().map(JSON: json)
		XCTAssertNotNil(object)
		XCTAssertNil(object?.nilValue) // without transform this is nil
		XCTAssertNotNil(object?.value)
		XCTAssertNotNil(object?.value?.one)
		XCTAssertNotNil(object?.value?.two)
		XCTAssertNotNil(object?.value?.three)
		XCTAssertNotNil(object?.arrayValue)
	}
}

class SingleMappableObject<T: Codable>: ImmutableMappable {
	let value: T
	
	required init(map: Map) throws {
		self.value = try map.value("value.single_value", using: CodableTransform<T>())
	}
}

class ArrayMappableObject<T: Codable>: ImmutableMappable {
	let value: [T]
	
	required init(map: Map) throws {
		self.value = try map.value("value.array_value", using: CodableTransform<T>())
	}
}

class MappableObject: ImmutableMappable {
	let value: CodableModel?
	let arrayValue: [CodableModel]?
	let nilValue: CodableModel?
	
	required init(map: Map) throws {
		self.nilValue = try? map.value("value")
		self.value = try? map.value("value", using: CodableTransform<CodableModel>())
		self.arrayValue = try? map.value("array_value", using: CodableTransform<[CodableModel]>())
	}
}

struct CodableModel: Codable {
	let one: String
	let two: Int
	let three: Bool
}
