//
//  VariableDefinitionTests.swift
//  Stardaze
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

import Stardaze
import XCTest

final class VariableDefinitionTests: XCTestCase {
    let stringFormatter = UnencodedStringFormatter()
    func testRepresentations() {
        let definition = VariableDefinition(key: "testString",
                                            type: "String",
                                            notNullable: true,
                                            value: .string("Hello!"))

        XCTAssertEqual(definition.accept(visitor: stringFormatter), "$testString: String!")
    }
}
