//
//  QueryOperationTests.swift
//  LTGQL
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

import LTGQL
import XCTest

final class QueryOperationTests: XCTestCase {
    func testUnnamed() {
        var query = QueryOperation(fields: [Field(name: "products", subFields: [Field(name: "id")])])

        XCTAssertEqual(query.userRepresentation(),
                       "{" +
                            "\n\tproducts {" +
                                "\n\t\tid" +
                            "\n\t}" +
                        "\n}")

        query.append(field: Field(name: "custom_collections", subFields: [Field(name: "id")]))

        XCTAssertEqual(query.userRepresentation(),
                       "{" +
                            "\n\tproducts {" +
                                "\n\t\tid" +
                            "\n\t}," +
                            "\n\tcustom_collections {" +
                                "\n\t\tid" +
                            "\n\t}" +
                        "\n}")
    }

    func testNamed() {
        var query = QueryOperation(name: "ProductList",
                                   fields: [Field(name: "products", subFields: [Field(name: "id")])])

        XCTAssertEqual(query.userRepresentation(),
                       "query ProductList {" +
                            "\n\tproducts {" +
                                "\n\t\tid" +
                            "\n\t}" +
                        "\n}")

        query.append(variableDefinition: VariableDefinition(key: "count", type: "Int"))

        XCTAssertEqual(query.userRepresentation(),
                       "query ProductList($count: Int) {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}" +
            "\n}")

    }
}
