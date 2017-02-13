//
//  DocumentTests.swift
//  LTGQL
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

import LTGQL
import XCTest

class DocumentTests: XCTestCase {
    let testDocument = Document(queryOperation: QueryOperation(fields: [Field(name: "products")]))
    func testUserRepresentation() {
        var copy = testDocument

        XCTAssertEqual(copy.userRepresentation(),
                       "{" +
                            "\n\tproducts" +
                        "\n}")

        copy.append(fragment: Fragment(name: "idFragment", type: "Product", fields: [Field(name: "id")]))
        XCTAssertEqual(copy.userRepresentation(),
                       "{" +
                        "\n\tproducts" +
            "\n}" +
            "\n" +
            "\nfragment idFragment on Product {" +
                "\n\tid" +
            "\n}")
    }

    func testAppendingMultipleFragments() {
        var copy = testDocument
        copy.append(fragments: [
            Fragment(name: "idFragment", type: "Product", fields: [Field(name: "id")]),
            Fragment(name: "titleFragment", type: "Product", fields: [Field(name: "title")])
            ])

        XCTAssertEqual(copy.userRepresentation(),
                       "{" +
                        "\n\tproducts" +
            "\n}" +
            "\n" +
            "\nfragment idFragment on Product {" +
                "\n\tid" +
            "\n}" +
            "\n" +
            "\nfragment titleFragment on Product {" +
                "\n\ttitle" +
            "\n}")
    }

    func testServerRepresentation() {
        var document = Document(queryOperation: QueryOperation(fields: [Field(name: "products")]))
        document.append(fragment: Fragment(name: "idFragment", type: "Product", fields: [Field(name: "id")]))
        XCTAssertEqual(document.encodedRepresentation(),
                       "%7B%0A%09products%0A%7D%0A%0Afragment%20idFragment%20on%20Product%20%7B%0A%09id%0A%7D")
    }
}
