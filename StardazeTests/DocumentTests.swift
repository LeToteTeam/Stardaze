//
//  DocumentTests.swift
//  Stardaze
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

import Stardaze
import XCTest

class DocumentTests: XCTestCase {
    let testDocument = Document(queryOperation: QueryOperation(name: "ProductList",
                                                               variableDefinitions: [
                                                                VariableDefinition(key: "count",
                                                                                   type: "Int",
                                                                                   value: .int(10))
        ],
                                                               fields: [Field(name: "products")]))
    func testUserRepresentation() {
        var copy = testDocument

        XCTAssertEqual(copy.userRepresentation(),
                       "query ProductList($count: Int) {" +
                            "\n\tproducts" +
                        "\n}" +
                        "\n{\"count\": 10}")

        copy.append(fragment: Fragment(name: "idFragment", type: "Product", fields: [Field(name: "id")]))
        XCTAssertEqual(copy.userRepresentation(),
                       "query ProductList($count: Int) {" +
                        "\n\tproducts" +
            "\n}" +
            "\n" +
            "\nfragment idFragment on Product {" +
                "\n\tid" +
            "\n}" +
            "\n{\"count\": 10}")
    }

    func testAppendingMultipleFragments() {
        var copy = testDocument
        copy.append(fragments: [
            Fragment(name: "idFragment", type: "Product", fields: [Field(name: "id")]),
            Fragment(name: "titleFragment", type: "Product", fields: [Field(name: "title")])
            ])

        XCTAssertEqual(copy.userRepresentation(),
                       "query ProductList($count: Int) {" +
                        "\n\tproducts" +
            "\n}" +
            "\n" +
            "\nfragment idFragment on Product {" +
                "\n\tid" +
            "\n}" +
            "\n" +
            "\nfragment titleFragment on Product {" +
                "\n\ttitle" +
            "\n}" +
            "\n{\"count\": 10}")
    }

    func testServerRepresentation() {
        var unnamedDocument = Document(queryOperation: QueryOperation(fields: [Field(name: "products")]))
        unnamedDocument.append(fragment: Fragment(name: "idFragment", type: "Product", fields: [Field(name: "id")]))

        XCTAssertEqual(unnamedDocument.encodedRepresentation(),
                       "query=%7B%20products%20%7D%20fragment%20idFragment%20on%20Product%20%7B%20id%20%7D")

        let namedDocument = Document(queryOperation:
            QueryOperation(name: "ProductList",
                           variableDefinitions: [VariableDefinition(key: "count", type: "Int", value: .int(10))],
                           fields: [Field(name: "id")]))

        XCTAssertEqual(namedDocument.encodedRepresentation(),
            "query=query%20ProductList($count:%20Int)%20%7B%20id%20%7D%20%7B%22count%22:%2010%7D&" +
            "operationName=ProductList&variables=%7B%22count%22:%2010%7D")
    }
}
