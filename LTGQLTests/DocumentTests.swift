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
    func testUserRepresentation() {
        var document = Document(queryOperation: QueryOperation(fields: [Field(name: "products")]))

        XCTAssertEqual(document.userRepresentation(),
                       "{" +
                            "\n\tproducts" +
                        "\n}")

        document.append(fragment: Fragment(name: "idFragment", type: "Product", fields: [Field(name: "id")]))
        XCTAssertEqual(document.userRepresentation(),
                       "{" +
                        "\n\tproducts" +
            "\n}" +
            "\n" +
            "\nfragment idFragment on Product {" +
                "\n\tid" +
            "\n}")
    }

    func testServerRepresentation() {
        var document = Document(queryOperation: QueryOperation(fields: [Field(name: "products")]))
        document.append(fragment: Fragment(name: "idFragment", type: "Product", fields: [Field(name: "id")]))
        XCTAssertEqual(document.serverRepresentation(),
                       "%7B%0A%09products%0A%7D%0A%0Afragment%20idFragment%20on%20Product%20%7B%0A%09id%0A%7D")
    }
}
