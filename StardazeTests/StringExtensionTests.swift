//
//  StringExtensionTests.swift
//  Stardaze
//
//  Created by William Wilson on 3/23/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

@testable import Stardaze
import XCTest

final class StringExtensionTests: XCTestCase {
    let unencodedStringFormatter = PrettyPrintedStringFormatter()

    func testStringFormatting() {
        XCTAssertEqual("hello".accept(visitor: unencodedStringFormatter), "\"hello\"")
    }
}
