//
//  DocumentTests.swift
//  Stardaze
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

import Stardaze
import XCTest

final class DocumentTests: XCTestCase {
    let testDocument = Document(queryOperation: QueryOperation(name: "ProductList",
                                                               variableDefinitions: [
                                                                VariableDefinition(key: "count",
                                                                                   type: "Int",
                                                                                   value: 10)
        ],
                                                               fields: ["products"]))
    func testUserRepresentation() {
        XCTAssertEqual(testDocument.stringify(encoded: false),
                       "query ProductList($count: Int) {" +
                            "\n\tproducts" +
                        "\n}" +
                        "\n\n{\"count\": 10}")

        let withFragment = testDocument.appended(fragment: Fragment(name: "idFragment",
                                                                    type: "Product",
                                                                    fields: ["id"]))

        XCTAssertEqual(withFragment.stringify(encoded: false),
                       "query ProductList($count: Int) {" +
                        "\n\tproducts" +
            "\n}" +
            "\n" +
            "\nfragment idFragment on Product {" +
                "\n\tid" +
            "\n}" +
            "\n\n{\"count\": 10}")
    }

    func testAppendingMultipleFragments() {
        let copy = testDocument.appended(fragments: [
            Fragment(name: "idFragment", type: "Product", fields: ["id"]),
            Fragment(name: "titleFragment", type: "Product", fields: ["title"])])

        XCTAssertEqual(copy.stringify(encoded: false),
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
            "\n\n{\"count\": 10}")
    }

    func testUnencodedParametersRepresentation() {
        let unnamedDocument = Document(queryOperation: QueryOperation(fields: ["products"]))
            .appended(fragment: Fragment(name: "idFragment", type: "Product", fields: ["id"]))

        let unnamedParameters = unnamedDocument.parameterize(encoded: true)

        XCTAssertEqual(unnamedParameters.count, 1)
        XCTAssertEqual(unnamedParameters["query"] as? String,
                       "%7B%20products%20%7D%20fragment%20idFragment%20on%20Product%20%7B%20id%20%7D")

        let namedDocument = Document(queryOperation:
            QueryOperation(name: "ProductList",
                           variableDefinitions: [VariableDefinition(key: "count", type: "Int", value: 10)],
                           fields: ["id"]))

        let namedParameters = namedDocument.parameterize(encoded: true)

        XCTAssertEqual(namedParameters.count, 3)
        XCTAssertEqual(namedParameters["query"] as? String,
                       "query%20ProductList($count:%20Int)%20%7B%20id%20%7D")
        XCTAssertEqual(namedParameters["operationName"] as? String, "ProductList")
        XCTAssertEqual(namedParameters["variables"] as? String, "%7B%22count%22:%2010%7D")
    }

    func testServerRepresentation() {
        let unnamedDocument = Document(queryOperation: QueryOperation(fields: ["products"]))
            .appended(fragment: Fragment(name: "idFragment", type: "Product", fields: ["id"]))

        XCTAssertEqual(unnamedDocument.stringify(encoded: true),
                       "query=%7B%20products%20%7D%20fragment%20idFragment%20on%20Product%20%7B%20id%20%7D")

        let namedDocument = Document(queryOperation:
            QueryOperation(name: "ProductList",
                           variableDefinitions: [VariableDefinition(key: "count", type: "Int", value: 10)],
                           fields: ["id"]))

        XCTAssertEqual(namedDocument.stringify(encoded: true),
            "query=query%20ProductList($count:%20Int)%20%7B%20id%20%7D%20%7B%22count%22:%2010%7D&" +
            "operationName=ProductList&variables=%7B%22count%22:%2010%7D")
    }

    func testServerParameterdRepresentation() {
        let fragment = Fragment(name: "idFragment", type: "Product", fields: ["id"])

        let unnamedDocument = Document(queryOperation: QueryOperation(fields: [Field(name: "products",
                                                                                     fragments: [fragment])]))
            .appended(fragment: fragment)

        let unnamedParameters = unnamedDocument.parameterize(encoded: false)

        XCTAssertEqual(unnamedParameters.count, 1)
        XCTAssertEqual(unnamedParameters["query"] as? String,

                       "{ products { ...idFragment } } fragment idFragment on Product { id }")

        let namedDocument = Document(queryOperation:
            QueryOperation(name: "ProductList",
                           variableDefinitions: [VariableDefinition(key: "count", type: "Int", value: 10)],
                           fields: ["id"]))

        let namedParameters = namedDocument.parameterize(encoded: false)

        XCTAssertEqual(namedParameters.count, 3)
        XCTAssertEqual(namedParameters["query"] as? String,

                       "query ProductList($count: Int) { id }")
        XCTAssertEqual(namedParameters["operationName"] as? String, "ProductList")
        XCTAssertEqual(namedParameters["variables"] as? String, "{\"count\": 10}")
    }
}
