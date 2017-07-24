//
//  ArgumentTests.swift
//  Stardaze
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

@testable import Stardaze
import XCTest

final class ArgumentTests: XCTestCase {
    enum TestEnum: String {
        case blue
    }

    let stringFormatter = OutputFormatter(outputOption: .prettyPrinted)

    func testBoolInitializer() {
        XCTAssertEqual(Argument(key: "bool", value: true).accept(visitor: stringFormatter), "bool: true")
    }

    func testDoubleInitializer() {
        XCTAssertEqual(Argument(key: "double", value: 3.145).accept(visitor: stringFormatter), "double: 3.145")
    }

    func testEnumInitializer() {
        XCTAssertEqual(Argument(key: "enum", value: TestEnum.blue).accept(visitor: stringFormatter), "enum: blue")
    }

    func testIntInitializer() {
        XCTAssertEqual(Argument(key: "id", value: 5).accept(visitor: stringFormatter), "id: 5")
    }

    func testListInitializer() {
        XCTAssertEqual(Argument(key: "list", value: [5,
                                                     0.7,
                                                     GraphQLEnum(TestEnum.blue)])?.accept(visitor: stringFormatter),
                       "list: [5, 0.7, blue]")
    }

    func testNullInitializer() {
        XCTAssertEqual(Argument(key: "null", value: nil).accept(visitor: stringFormatter), "null: null")
    }

    func testObjectInitializer() {
        XCTAssertEqual(Argument(key: "object",
                                value: ["key": "value"])?.accept(visitor: stringFormatter), "object: {key: \"value\"}")
    }

    func testStringInitializer() {
        XCTAssertEqual(Argument(key: "string", value: "hello").accept(visitor: stringFormatter), "string: \"hello\"")
    }
}
