//
//  ArgumentTests.swift
//  Stardaze
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

import Stardaze
import XCTest

final class ArgumentTests: XCTestCase {
    let stringFormatter = UnencodedStringFormatter()
    let testArgument = Argument(key: "id", value: .int(5))
    func testUserRepresentation() {
        XCTAssertEqual(testArgument.accept(visitor: stringFormatter), "id: 5")
    }
}
