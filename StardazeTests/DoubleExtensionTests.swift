//
//  DoubleExtensionTests.swift
//  Stardaze
//
//  Created by William Wilson on 3/22/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

@testable import Stardaze
import XCTest

final class DoubleExtensionTests: XCTestCase {
    let unencodedStringFormatter = OutputFormatter(outputOption: .prettyPrinted)
    func testStringFormatting() {
        XCTAssertEqual(5.324.accept(visitor: unencodedStringFormatter), "5.324")
        XCTAssertEqual(1.0.accept(visitor: unencodedStringFormatter), "1.0")
    }
}
