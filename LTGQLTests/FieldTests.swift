//
//  FieldTests.swift
//  LTGQL
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

import LTGQL
import XCTest

final class FieldTests: XCTestCase {
    let testField = Field(name: "test_field")

    func testUserRepresentation() {
        XCTAssertEqual(testField.userRepresentation(depth: 3), "\t\t\ttest_field")
    }

    func testAlias() {
        var field = Field(name: "test_field", alias: "testField")

        XCTAssertEqual(field.userRepresentation(depth: 0), "testField: test_field")

        field.append(subField: Field(name: "id"))

        XCTAssertEqual(field.userRepresentation(depth: 0),
                       "testField: test_field {" +
                            "\n\tid" +
                        "\n}")
    }

    func testArguments() {
        var copy = testField
        copy.append(argument: Argument(key: "id", value: .int(5)))

        XCTAssertEqual(copy.userRepresentation(depth: 0), "test_field(id: 5)")

        copy.append(argument: Argument(key: "color", value: .enumeration("brown")))

        XCTAssertEqual(copy.userRepresentation(depth: 0), "test_field(id: 5, color: brown)")

        copy.append(subField: Field(name: "id"))

        XCTAssertEqual(copy.userRepresentation(depth: 0),
                       "test_field(id: 5, color: brown) {" +
                            "\n\tid" +
                        "\n}")
    }

    func testDirectives() {
        var copy = testField
        copy.append(directive: .include(Variable("testVar")))

        XCTAssertEqual(copy.userRepresentation(depth: 0), "test_field @include(if: $testVar)")

        copy.append(directive: .deprecated(Variable("deprecationReason")))

        XCTAssertEqual(copy.userRepresentation(depth: 0), "test_field @include(if: $testVar), " +
            "@deprecated(reason: $deprecationReason)")

        copy.append(argument: Argument(key: "id", value: .int(5)))

        XCTAssertEqual(copy.userRepresentation(depth: 0), "test_field(id: 5) @include(if: $testVar), " +
            "@deprecated(reason: $deprecationReason)")

        copy.append(subField: Field(name: "id"))

        XCTAssertEqual(copy.userRepresentation(depth: 0),
                       "test_field(id: 5) @include(if: $testVar), @deprecated(reason: $deprecationReason) {" +
                            "\n\tid" +
                        "\n}")
    }

    func testFragments() {
        var copy = testField
        copy.append(fragment: Fragment(name: "testFragment", type: "TestObject", fields: [Field(name: "id")]))

        XCTAssertEqual(copy.userRepresentation(depth: 0),
                       "test_field {" +
                            "\n\t...testFragment" +
                        "\n}")

        copy.append(fragment: Fragment(name: "titleFragment", type: "TestObject", fields: [Field(name: "title")]))

        XCTAssertEqual(copy.userRepresentation(depth: 0),
                       "test_field {" +
                            "\n\t...testFragment" +
                            "\n\t...titleFragment" +
                        "\n}")

        copy.append(subField: Field(name: "customer_photos", subFields: [
            Field(name: "medium_url")
            ]))

        XCTAssertEqual(copy.userRepresentation(depth: 0),
                       "test_field {" +
                            "\n\tcustomer_photos {" +
                                "\n\t\tmedium_url" +
                            "\n\t}" +
                            "\n\t...testFragment" +
                            "\n\t...titleFragment" +
                        "\n}")
    }
}
