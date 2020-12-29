//
//  DecimalTransformTests.swift
//  ObjectMapper
//
//  Created by HanleyLee on 12/29/20.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2020 Hanley Lee
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

import XCTest
import ObjectMapper

class DecimalTransformTests: XCTestCase {

	let mapper = Mapper<DecimalType>()

	func testNSDecimalNumberTransform() {
		let int: Int = 11
		let double: Double = 11.11
		let intString = "11"
		let doubleString = "11.11"
		let JSONString = "{\"double\" : \(double), \"int\" : \(int), \"intString\" : \"\(intString)\", \"doubleString\" : \"\(doubleString)\"}"

		let mappedObject = mapper.map(JSONString: JSONString)

		XCTAssertNotNil(mappedObject)
		XCTAssertEqual(mappedObject?.int, Decimal(int))
		XCTAssertEqual(mappedObject?.double, Decimal(double))
		XCTAssertEqual(mappedObject?.intString, Decimal(string: intString))
		XCTAssertEqual(mappedObject?.doubleString, Decimal(string: doubleString))
	}
}

class DecimalType: Mappable {

	var int: Decimal?
	var double: Decimal?
	var intString: Decimal?
	var doubleString: Decimal?

	init(){ }

	required init?(map: Map){ }

	func mapping(map: Map) {
		int <- (map["int"], DecimalTransform())
		double <- (map["double"], DecimalTransform())
		intString <- (map["intString"], DecimalTransform())
		doubleString <- (map["doubleString"], DecimalTransform())
	}
}
