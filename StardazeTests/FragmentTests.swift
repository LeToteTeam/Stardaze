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
    let testFragment: Fragment = Fragment(name: "testFragment", type: "TestObject", fields: [Field(name: "id")])

    func testUserRepresentation() {
        XCTAssertEqual(testFragment.userRepresentation(depth: 3), "\t\t\t...testFragment")
    }

    func testUserDefinitionRepresentation() {
        XCTAssertEqual(testFragment.userDefinitionRepresentation(),
                       "fragment testFragment on TestObject {" +
                            "\n\tid" +
                        "\n}")
    }

    func testAppendFields() {
        var copy = testFragment
        copy.append(field: Field(name: "customer_photos", alias: "customerPhotos", subFields: [
            Field(name: "small_url")
            ]))

        XCTAssertEqual(copy.userRepresentation(depth: 0), "...testFragment")

        XCTAssertEqual(copy.userDefinitionRepresentation(),
                       "fragment testFragment on TestObject {" +
                            "\n\tid" +
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

        XCTAssertEqual(copy.userRepresentation(depth: 0), "...testFragment")

        XCTAssertEqual(copy.userDefinitionRepresentation(),
                       "fragment testFragment on TestObject {" +
                            "\n\tid" +
                            "\n\tcustomerPhotos: customer_photos {" +
                                "\n\t\tsmall_url" +
                            "\n\t}" +
                            "\n\ttitle" +
                        "\n}")
    }
}
