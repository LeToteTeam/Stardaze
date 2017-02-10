//
//  VariableDefinitionTests.swift
//  LTGQL
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

import LTGQL
import XCTest

final class VariableDefinitionTests: XCTestCase {
    func testUserRepresentation() {
        XCTAssertEqual(VariableDefinition(key: "testVar", type: "TestObject", notNullable: true).userRepresentation(),
                       "$testVar: TestObject!")
    }
}
