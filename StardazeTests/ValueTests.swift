//
//  ValueTests.swift
//  Stardaze
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

import Stardaze
import XCTest

final class ValueTests: XCTestCase {
    let readablePrinter = ReadablePrinter()
    func testBoolean() {
        XCTAssertEqual(Value.boolean(false).accept(visitor: readablePrinter), "false")
    }

    func testDouble() {
        XCTAssertEqual(Value.double(5).accept(visitor: readablePrinter), "5.0")
        XCTAssertEqual(Value.double(9.9999).accept(visitor: readablePrinter), "9.9999")
    }

    func testEnumeration() {
        XCTAssertEqual(Value.enumeration("testEnum").accept(visitor: readablePrinter), "testEnum")
    }

    func testInt() {
        XCTAssertEqual(Value.int(5).accept(visitor: readablePrinter), "5")
    }

    func testList() {
        XCTAssertEqual(Value.list([
            .boolean(false),
            .double(5.0),
            .enumeration("testEnum"),
            .int(5),
            .null,
            .string("testString"),
            .variable(Variable("testVar"))]).accept(visitor: readablePrinter),
                       "[false, 5.0, testEnum, 5, null, \"testString\", $testVar]")
    }

    func testNull() {
        XCTAssertEqual(Value.null.accept(visitor: readablePrinter), "null")
    }

    func testObject() {
        // There is no guaranteed order on dictionaries, so testing with multiple key value pairs is unpredictable.
        XCTAssertEqual(Value.object(["string": .string("string")]).accept(visitor: readablePrinter),
                       "{string: \"string\"}")
    }

    func testString() {
        XCTAssertEqual(Value.string("testString").accept(visitor: readablePrinter), "\"testString\"")
    }

    func testVariable() {
        XCTAssertEqual(Value.variable(Variable("testVar")).accept(visitor: readablePrinter), "$testVar")
    }
}
