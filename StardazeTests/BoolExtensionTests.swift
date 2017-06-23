//
//  BoolExtensionTests.swift
//  Stardaze
//
//  Created by William Wilson on 3/22/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

@testable import Stardaze
import XCTest

final class BoolExtensionTests: XCTestCase {
    let unencodedStringFormatter = PrettyPrintedStringFormatter()

    func testStringFormatting() {
        XCTAssertEqual(false.accept(visitor: unencodedStringFormatter), "false")
        XCTAssertEqual(true.accept(visitor: unencodedStringFormatter), "true")
    }
}
