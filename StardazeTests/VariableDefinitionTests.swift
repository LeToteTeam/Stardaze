//
//  VariableDefinitionTests.swift
//  Stardaze
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

@testable import Stardaze
import XCTest

final class VariableDefinitionTests: XCTestCase {
    enum TestEnum: String {
        case blue
    }

    let stringFormatter = PrettyPrintedStringFormatter()

    func testBoolInitializer() {
        XCTAssertEqual(VariableDefinition(key: "testString",
                                          type: "Bool",
                                          notNullable: true,
                                          value: true).accept(visitor: stringFormatter),
                       "$testString: Bool!")
    }

    func testDoubleInitializer() {
        XCTAssertEqual(VariableDefinition(key: "test",
                                          type: "Double",
                                          notNullable: false,
                                          value: 0.5).accept(visitor: stringFormatter),
                       "$test: Double")
    }

    func testEnumInitializer() {
        XCTAssertEqual(VariableDefinition(key: "enum",
                                          type: "Enum",
                                          notNullable: false,
                                          value: TestEnum.blue).accept(visitor: stringFormatter),
                       "$enum: Enum")
    }

    func testIntInitializer() {
        XCTAssertEqual(VariableDefinition(key: "test",
                                          type: "Int",
                                          notNullable: false,
                                          value: 1).accept(visitor: stringFormatter),
                       "$test: Int")
    }

    func testListInitializer() {
        XCTAssertEqual(VariableDefinition(key: "list",
                                          type: "List",
                                          notNullable: false,
                                          value: [3, "hi"])?.accept(visitor: stringFormatter),
                       "$list: List")
    }

    func testNullInitializer() {
        XCTAssertEqual(VariableDefinition(key: "test",
                                          type: "Null",
                                          notNullable: true,
                                          value: nil).accept(visitor: stringFormatter),
                       "$test: Null!")
    }

    func testObjectInitializer() {
        XCTAssertEqual(VariableDefinition(key: "object",
                                          type: "Object",
                                          notNullable: true,
                                          value: ["hello": 5])?.accept(visitor: stringFormatter),
                       "$object: Object!")
    }

    func testStringInitializer() {
        XCTAssertEqual(VariableDefinition(key: "string",
                                          type: "String",
                                          notNullable: false,
                                          value: "hey").accept(visitor: stringFormatter),
                       "$string: String")
    }
}
