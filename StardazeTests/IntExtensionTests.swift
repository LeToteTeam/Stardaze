//
//  IntExtensionTests.swift
//  Stardaze
//
//  Created by William Wilson on 3/22/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

@testable import Stardaze
import XCTest

final class IntExtensionTests: XCTestCase {
    let unencodedStringFormatter = UnencodedStringFormatter()

    func testStringFormatting() {
        XCTAssertEqual(3829.accept(visitor: unencodedStringFormatter), "3829")
        XCTAssertEqual((-2894).accept(visitor: unencodedStringFormatter), "-2894")
        XCTAssertEqual(0.accept(visitor: unencodedStringFormatter), "0")
    }
}
