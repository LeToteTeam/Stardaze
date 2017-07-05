//
//  FieldTests.swift
//  Stardaze
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

@testable import Stardaze
import XCTest

final class FieldTests: XCTestCase {
    enum TestEnum: String {
        case brown
    }

    let unencodedStringFormatter = OutputFormatter(outputOption: .prettyPrinted, parameterize: false)
    let testField = Field(name: "test_field")

    func testUserRepresentation() {
        XCTAssertEqual(testField.accept(visitor: unencodedStringFormatter), "test_field")
    }

    func testAlias() {
        let field = Field(name: "test_field", alias: "testField")

        XCTAssertEqual(field.accept(visitor: unencodedStringFormatter), "testField: test_field")

        let withID = field.appended(subField: "id")

        XCTAssertEqual(withID.accept(visitor: unencodedStringFormatter),
                       "testField: test_field {" +
                            "\n\tid" +
                        "\n}")
    }

    func testArguments() {
        let copy = testField.appended(argument: Argument(key: "id", value: 5))

        XCTAssertEqual(copy.accept(visitor: unencodedStringFormatter), "test_field(id: 5)")

        let withColor = copy.appended(argument: Argument(key: "color", value: TestEnum.brown))

        XCTAssertEqual(withColor.accept(visitor: unencodedStringFormatter), "test_field(id: 5, color: brown)")

        let withID = withColor.appended(subField: "id")

        XCTAssertEqual(withID.accept(visitor: unencodedStringFormatter),
                       "test_field(id: 5, color: brown) {" +
                            "\n\tid" +
                        "\n}")
    }

    func testAppendingMultipleArguments() {
        let copy = testField.appended(arguments: [
            Argument(key: "id", value: 5),
            Argument(key: "color", value: TestEnum.brown)
            ])

        XCTAssertEqual(copy.accept(visitor: unencodedStringFormatter), "test_field(id: 5, color: brown)")
    }

    func testDirectives() {
        let copy = testField.appended(directive: .include(Variable("testVar")))

        XCTAssertEqual(copy.accept(visitor: unencodedStringFormatter), "test_field @include(if: $testVar)")

        let withDeprecation = copy.appended(directive: .deprecated(Variable("deprecationReason")))

        XCTAssertEqual(withDeprecation.accept(visitor: unencodedStringFormatter),
                       "test_field @include(if: $testVar), @deprecated(reason: $deprecationReason)")

        let withID = withDeprecation.appended(argument: Argument(key: "id", value: 5))

        XCTAssertEqual(withID.accept(visitor: unencodedStringFormatter), "test_field(id: 5) @include(if: $testVar), " +
            "@deprecated(reason: $deprecationReason)")

        let withIDField = withID.appended(subField: "id")

        XCTAssertEqual(withIDField.accept(visitor: unencodedStringFormatter),
                       "test_field(id: 5) @include(if: $testVar), @deprecated(reason: $deprecationReason) {" +
                            "\n\tid" +
                        "\n}")
    }

    func testAppendingMultipleDirectives() {
        let copy = testField.appended(directives: [
            .skip(Variable("testVar")),
            .deprecated(Variable("deprecationReason"))
            ])

        XCTAssertEqual(copy.accept(visitor: unencodedStringFormatter), "test_field @skip(if: $testVar), " +
            "@deprecated(reason: $deprecationReason)")
    }

    func testFragments() {
        let copy = testField.appended(fragment: Fragment(name: "testFragment",
                                                         type: "TestObject",
                                                         fields: ["id"]))

        XCTAssertEqual(copy.accept(visitor: unencodedStringFormatter),
                       "test_field {" +
                            "\n\t...testFragment" +
                        "\n}")

        let withTitleFragment = copy.appended(fragment: Fragment(name: "titleFragment",
                                                                 type: "TestObject",
                                                                 fields: [Field(name: "title")]))

        XCTAssertEqual(withTitleFragment.accept(visitor: unencodedStringFormatter),
                       "test_field {" +
                            "\n\t...testFragment" +
                            "\n\t...titleFragment" +
                        "\n}")

        let withPhotos = withTitleFragment.appended(subField: Field(name: "customer_photos", subFields: [
            "medium_url"
            ]))

        XCTAssertEqual(withPhotos.accept(visitor: unencodedStringFormatter),
                       "test_field {" +
                            "\n\tcustomer_photos {" +
                                "\n\t\tmedium_url" +
                            "\n\t}" +
                            "\n\t...testFragment" +
                            "\n\t...titleFragment" +
                        "\n}")
    }

    func testAppendingMultipleFragments() {
        let copy = testField.appended(fragments: [
            Fragment(name: "testFragment", type: "TestObject", fields: ["id"]),
            Fragment(name: "titleFragment", type: "TestObject", fields: ["title"])
            ])

        XCTAssertEqual(copy.accept(visitor: unencodedStringFormatter),
                       "test_field {" +
                            "\n\t...testFragment" +
                            "\n\t...titleFragment" +
                        "\n}")
    }

    func testAppendingMultipleFields() {
        let copy = testField.appended(subFields: ["id", "title"])

        XCTAssertEqual(copy.accept(visitor: unencodedStringFormatter),
                       "test_field {" +
                            "\n\tid" +
                            "\n\ttitle" +
                        "\n}")
    }
}
