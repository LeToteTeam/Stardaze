//
//  ValueTests.swift
//  LTGQL
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

import LTGQL
import XCTest

final class ValueTests: XCTestCase {
    func testBoolean() {
        XCTAssertEqual(Value.extractString(value: .boolean(false)), "false")
    }

    func testDouble() {
        XCTAssertEqual(Value.extractString(value: .double(5)), "5.0")
        XCTAssertEqual(Value.extractString(value: .double(9.9999)), "9.9999")
    }

    func testEnumeration() {
        XCTAssertEqual(Value.extractString(value: .enumeration("testEnum")), "testEnum")
    }

    func testInt() {
        XCTAssertEqual(Value.extractString(value: .int(5)), "5")
    }

    func testList() {
        XCTAssertEqual(Value.extractString(value: .list([
            .boolean(false),
            .double(5.0),
            .enumeration("testEnum"),
            .int(5),
            .null,
            .string("testString"),
            .variable(Variable("testVar"))])),
                       "[false, 5.0, testEnum, 5, null, \"testString\", $testVar]")
    }

    func testNull() {
        XCTAssertEqual(Value.extractString(value: .null), "null")
    }

    func testObject() {
        // There is no guaranteed order on dictionaries, so testing with multiple key value pairs is unpredictable.
        XCTAssertEqual(Value.extractString(value: .object(["boolean": .boolean(false)])), "{boolean: false}")
    }

    func testString() {
        XCTAssertEqual(Value.extractString(value: .string("testString")), "\"testString\"")
    }

    func testVariable() {
        XCTAssertEqual(Value.extractString(value: .variable(Variable("testVar"))), "$testVar")
    }
}
