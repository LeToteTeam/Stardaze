//
//  FragmentTests.swift
//  Stardaze
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

@testable import Stardaze
import XCTest

final class FragmentTests: XCTestCase {
    let unencodedStringFormatter = UnencodedStringFormatter()
    let testFragment = Fragment(name: "testFragment", type: "TestObject", fields: ["id"])

    func testUserDefinitionRepresentation() {
        XCTAssertEqual(testFragment.accept(visitor: unencodedStringFormatter),
                       "fragment testFragment on TestObject {" +
                            "\n\tid" +
                        "\n}")
    }

    func testAppendFields() {
        var copy = testFragment
        copy.append(field: Field(name: "customer_photos", alias: "customerPhotos", subFields: ["small_url"]))

        XCTAssertEqual(copy.accept(visitor: unencodedStringFormatter),
                       "fragment testFragment on TestObject {" +
                            "\n\tid," +
                            "\n\tcustomerPhotos: customer_photos {" +
                                "\n\t\tsmall_url" +
                            "\n\t}" +
                        "\n}")
    }

    func testAppendMultipleFields() {
        var copy = testFragment
        copy.append(fields: [
            Field(name: "customer_photos", alias: "customerPhotos", subFields: ["small_url"]),
            "title"
            ])

        XCTAssertEqual(copy.accept(visitor: unencodedStringFormatter),
                       "fragment testFragment on TestObject {" +
                            "\n\tid," +
                            "\n\tcustomerPhotos: customer_photos {" +
                                "\n\t\tsmall_url" +
                            "\n\t}," +
                            "\n\ttitle" +
                        "\n}")
    }
}
