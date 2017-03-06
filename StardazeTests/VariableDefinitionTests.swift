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
    func testRepresentations() {
        let definition = VariableDefinition(key: "testString",
                                            type: "String",
                                            notNullable: true,
                                            value: .string("Hello!"))

        XCTAssertEqual(definition.userRepresentation(), "$testString: String!")
        XCTAssertEqual(definition.valueRepresentation(), "\"testString\": \"Hello!\"")
    }
}
