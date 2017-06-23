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
        XCTAssertEqual(testDocument.stringify(format: .prettyPrinted),
                       "query ProductList($count: Int) {" +
                            "\n\tproducts" +
                        "\n}" +
                        "\n" +
                        "\n{" +
                            "\n\t\"count\": 10" +
                        "\n}")

        let withFragment = testDocument.appended(fragment: Fragment(name: "idFragment",
                                                                    type: "Product",
                                                                    fields: ["id"]))

        XCTAssertEqual(withFragment.stringify(format: .prettyPrinted),
                       "query ProductList($count: Int) {" +
                        "\n\tproducts" +
            "\n}" +
            "\n" +
            "\nfragment idFragment on Product {" +
                "\n\tid" +
            "\n}" +
            "\n" +
            "\n{" +
                "\n\t\"count\": 10" +
            "\n}")
    }

    func testCompactStringRepresentation() {
        XCTAssertEqual(testDocument.stringify(format: .prettyPrinted),
                       "query ProductList($count: Int) {" +
                            "\n\tproducts" +
                        "\n}" +
                        "\n" +
                        "\n{" +
                            "\n\t\"count\": 10" +
                        "\n}")

        let withFragment = testDocument.appended(fragment: Fragment(name: "idFragment",
                                                                    type: "Product",
                                                                    fields: ["id"]))

        XCTAssertEqual(withFragment.stringify(format: .prettyPrinted),
                       "query ProductList($count: Int) {" +
                            "\n\tproducts" +
                        "\n}" +
                        "\n" +
                        "\nfragment idFragment on Product {" +
                            "\n\tid" +
                        "\n}" +
                        "\n" +
                        "\n{" +
                            "\n\t\"count\": 10" +
                        "\n}")
    }

    func testAppendingMultipleFragments() {
        let copy = testDocument.appended(fragments: [
            Fragment(name: "idFragment", type: "Product", fields: ["id"]),
            Fragment(name: "titleFragment", type: "Product", fields: ["title"])])

        XCTAssertEqual(copy.stringify(format: .compact),
                       "query=query ProductList($count: Int) { products } fragment idFragment on Product { id }" +
            "fragment titleFragment on Product { title }&operationName=ProductList&variables={ \"count\": 10 }")
    }

    func testEncodedParametersRepresentation() {
        let unnamedDocument = Document(queryOperation: QueryOperation(fields: ["products"]))
            .appended(fragment: Fragment(name: "idFragment", type: "Product", fields: ["id"]))

        let unnamedParameters = unnamedDocument.parameterize(format: .encoded)

        XCTAssertEqual(unnamedParameters.count, 1)
        XCTAssertEqual(unnamedParameters["query"] as? String,
                       "%7B%20products%20%7D%20fragment%20idFragment%20on%20Product%20%7B%20id%20%7D")

        let namedDocument = Document(queryOperation:
            QueryOperation(name: "ProductList",
                           variableDefinitions: [VariableDefinition(key: "count", type: "Int", value: 10)],
                           fields: ["id"]))

        let namedParameters = namedDocument.parameterize(format: .encoded)

        XCTAssertEqual(namedParameters.count, 3)
        XCTAssertEqual(namedParameters["query"] as? String,
                       "query%20ProductList($count:%20Int)%20%7B%20id%20%7D")
        XCTAssertEqual(namedParameters["operationName"] as? String, "ProductList")
        XCTAssertEqual(namedParameters["variables"] as? String, "%7B%20%22count%22:%2010%20%7D")
    }

    func testServerRepresentation() {
        let unnamedDocument = Document(queryOperation: QueryOperation(fields: ["products"]))
            .appended(fragment: Fragment(name: "idFragment", type: "Product", fields: ["id"]))

        XCTAssertEqual(unnamedDocument.stringify(format: .encoded),
                       "query=%7B%20products%20%7D%20fragment%20idFragment%20on%20Product%20%7B%20id%20%7D")

        let namedDocument = Document(queryOperation:
            QueryOperation(name: "ProductList",
                           variableDefinitions: [VariableDefinition(key: "count", type: "Int", value: 10)],
                           fields: ["id"]))

        XCTAssertEqual(namedDocument.stringify(format: .encoded),
            "query=query%20ProductList($count:%20Int)%20%7B%20id%20%7D" +
            "&operationName=ProductList&variables=%7B%20%22count%22:%2010%20%7D")
    }

    func testPrettyPrintedParametersRepresentation() {
        let fragment = Fragment(name: "idFragment", type: "Product", fields: ["id"])

        let unnamedDocument = Document(queryOperation: QueryOperation(fields: [Field(name: "products",
                                                                                     fragments: [fragment])]))
            .appended(fragment: fragment)

        let unnamedParameters = unnamedDocument.parameterize(format: .prettyPrinted)

        XCTAssertEqual(unnamedParameters.count, 1)
        XCTAssertEqual(unnamedParameters["query"] as? String,

                       "{" +
                            "\n\tproducts {" +
                                "\n\t\t...idFragment" +
                            "\n\t}" +
                        "\n}" +
                        "\n" +
                        "\nfragment idFragment on Product {" +
                            "\n\tid" +
                        "\n}")

        let namedDocument = Document(queryOperation:
            QueryOperation(name: "ProductList",
                           variableDefinitions: [VariableDefinition(key: "count", type: "Int", value: 10)],
                           fields: ["id"]))

        let namedParameters = namedDocument.parameterize(format: .prettyPrinted)

        XCTAssertEqual(namedParameters.count, 3)
        XCTAssertEqual(namedParameters["query"] as? String,

                       "query ProductList($count: Int) {" +
                            "\n\tid" +
                        "\n}")
        XCTAssertEqual(namedParameters["operationName"] as? String, "ProductList")
        XCTAssertEqual(namedParameters["variables"] as? String, "{" +
                                                                    "\n\t\"count\": 10" +
                                                                "\n}")
    }

    func testCompactParamatersRepresentation() {
        let fragment = Fragment(name: "idFragment", type: "Product", fields: ["id"])

        let unnamedDocument = Document(queryOperation: QueryOperation(fields: [Field(name: "products",
                                                                                     fragments: [fragment])]))
            .appended(fragment: fragment)

        let unnamedParameters = unnamedDocument.parameterize(format: .compact)

        XCTAssertEqual(unnamedParameters.count, 1)
        XCTAssertEqual(unnamedParameters["query"] as? String,
                       "{ products { ...idFragment } } fragment idFragment on Product { id }")

        let namedDocument = Document(queryOperation:
            QueryOperation(name: "ProductList",
                           variableDefinitions: [VariableDefinition(key: "count", type: "Int", value: 10)],
                           fields: ["id"]))

        let namedParameters = namedDocument.parameterize(format: .compact)

        XCTAssertEqual(namedParameters.count, 3)
        XCTAssertEqual(namedParameters["query"] as? String, "query ProductList($count: Int) { id }")
        XCTAssertEqual(namedParameters["operationName"] as? String, "ProductList")
        XCTAssertEqual(namedParameters["variables"] as? String, "{ \"count\": 10 }")
    }
}
