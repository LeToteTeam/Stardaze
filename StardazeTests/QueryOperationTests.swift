//
//  QueryOperationTests.swift
//  Stardaze
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

import Stardaze
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

        query.append(fields: [
            Field(name: "title"),
            Field(name: "name")
            ])

        XCTAssertEqual(query.userRepresentation(),
                       "{" +
                            "\n\tproducts {" +
                                "\n\t\tid" +
                            "\n\t}," +
                            "\n\tcustom_collections {" +
                                "\n\t\tid" +
                            "\n\t}," +
                            "\n\ttitle," +
                            "\n\tname" +
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

        query.append(variableDefinition: VariableDefinition(key: "count", type: "Int", value: .int(10)))

        XCTAssertEqual(query.userRepresentation(),
                       "query ProductList($count: Int) {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}" +
            "\n}")

        XCTAssertEqual(query.valueRepresentations(), "{\"count\": 10}")

        query.append(variableDefinitions: [
            VariableDefinition(key: "limit", type: "Int", value: .int(10)),
            VariableDefinition(key: "color", type: "Enum", value: .enumeration("blue"))
            ])

        XCTAssertEqual(query.userRepresentation(),
                       "query ProductList($count: Int, $limit: Int, $color: Enum) {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}" +
            "\n}")

        XCTAssertEqual(query.valueRepresentations(), "{\"count\": 10, \"limit\": 10, \"color\": blue}")

        query.append(fields: [
            Field(name: "title"),
            Field(name: "name")
            ])

        XCTAssertEqual(query.userRepresentation(),
                       "query ProductList($count: Int, $limit: Int, $color: Enum) {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}," +
                        "\n\ttitle," +
                        "\n\tname" +
            "\n}")
    }

    func testMutation() {
        var mutation = QueryOperation(name: "ProductList",
                                      mutating: true,
                                      fields: [Field(name: "products", subFields: [Field(name: "id")])])

        XCTAssertEqual(mutation.userRepresentation(),
                       "mutation ProductList {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}" +
            "\n}")

        mutation.append(variableDefinition: VariableDefinition(key: "count", type: "Int", value: .int(10)))

        XCTAssertEqual(mutation.userRepresentation(),
                       "mutation ProductList($count: Int) {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}" +
            "\n}")

        XCTAssertEqual(mutation.valueRepresentations(), "{\"count\": 10}")

        mutation.append(variableDefinitions: [
            VariableDefinition(key: "limit", type: "Int", value: .int(10)),
            VariableDefinition(key: "color", type: "Enum", value: .enumeration("blue"))
            ])

        XCTAssertEqual(mutation.userRepresentation(),
                       "mutation ProductList($count: Int, $limit: Int, $color: Enum) {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}" +
            "\n}")

        XCTAssertEqual(mutation.valueRepresentations(), "{\"count\": 10, \"limit\": 10, \"color\": blue}")

        mutation.append(fields: [
            Field(name: "title"),
            Field(name: "name")
            ])

        XCTAssertEqual(mutation.userRepresentation(),
                       "mutation ProductList($count: Int, $limit: Int, $color: Enum) {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}," +
                        "\n\ttitle," +
                        "\n\tname" +
            "\n}")
    }
}
