//
//  DateFormatterTransform.swift
//  ObjectMapper
//
//  Created by Tristan Himmelman on 2015-03-09.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014-2016 Hearst
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

open class DateFormatterTransform: TransformType {
	public typealias Object = Date
	public typealias JSON = String
	
	let dateFormatter: DateFormatter
	let dateFormatter2: DateFormatter
	
	public init(dateFormatter: DateFormatter) {
		self.dateFormatter = dateFormatter
		self.dateFormatter2 = dateFormatter
	}
	
	public init(dateFormatter: DateFormatter, dateFormatter2: DateFormatter) {
		self.dateFormatter = dateFormatter
		self.dateFormatter2 = dateFormatter2
	}
	
	public func transformFromJSON(_ value: Any?) -> Date? {
		if let dateString = value as? String {
			if let date = dateFormatter.date(from: dateString) {
				return date
			} else {
				return dateFormatter2.date(from: dateString)
			}
		}
		return nil
	}
	
	public func transformToJSON(_ value: Date?) -> String? {
		if let date = value {
			return dateFormatter.string(from: date)
		}
		return nil
	}
}

open class NSDateFormatterTransform: TransformType {
	public typealias Object = NSDate
	public typealias JSON = String
	
	let dateFormatter: DateFormatter
	let dateFormatter2: DateFormatter
	
	public init(dateFormatter: DateFormatter) {
		self.dateFormatter = dateFormatter
		self.dateFormatter2 = dateFormatter
	}
	
	public init(dateFormatter: DateFormatter, dateFormatter2: DateFormatter) {
		self.dateFormatter = dateFormatter
		self.dateFormatter2 = dateFormatter2
	}
	
	public func transformFromJSON(_ value: Any?) -> NSDate? {
		if let dateString = value as? String {
			if let date = dateFormatter.date(from: dateString) {
				return date as NSDate?
			} else {
				return dateFormatter2.date(from: dateString) as NSDate?
			}
		}
		return nil
	}
	
	public func transformToJSON(_ value: NSDate?) -> String? {
		if let date = value {
			return dateFormatter.string(from: date as Date)
		}
		return nil
	}
}
