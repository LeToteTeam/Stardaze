//
//  FragmentTests.swift
//  Stardaze
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

import Stardaze
import XCTest

final class FragmentTests: XCTestCase {
    let readablePrinter = ReadablePrinter()
    let testFragment = Fragment(name: "testFragment", type: "TestObject", fields: [Field(name: "id")])

    func testUserDefinitionRepresentation() {
        XCTAssertEqual(testFragment.accept(visitor: readablePrinter),
                       "fragment testFragment on TestObject {" +
                            "\n\tid" +
                        "\n}")
    }

    func testAppendFields() {
        var copy = testFragment
        copy.append(field: Field(name: "customer_photos", alias: "customerPhotos", subFields: [
            Field(name: "small_url")
            ]))

        XCTAssertEqual(copy.accept(visitor: readablePrinter),
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
            Field(name: "customer_photos", alias: "customerPhotos", subFields: [
                Field(name: "small_url")
                ]),
            Field(name: "title")
            ])

        XCTAssertEqual(copy.accept(visitor: readablePrinter),
                       "fragment testFragment on TestObject {" +
                            "\n\tid," +
                            "\n\tcustomerPhotos: customer_photos {" +
                                "\n\t\tsmall_url" +
                            "\n\t}," +
                            "\n\ttitle" +
                        "\n}")
    }
}
