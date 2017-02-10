//
//  ArgumentTests.swift
//  LTGQL
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

import LTGQL
import XCTest

final class ArgumentTests: XCTestCase {
    let testArgument = Argument(key: "id", value: .int(5))
    func testUserRepresentation() {
        XCTAssertEqual(testArgument.userRepresentation(), "id: 5")
    }
}
