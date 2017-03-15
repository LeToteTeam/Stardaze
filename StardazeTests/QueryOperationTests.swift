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
    let unencodedStringFormatter = UnencodedStringFormatter()
    func testUnnamed() {
        var query = QueryOperation(fields: [Field(name: "products", subFields: [Field(name: "id")])])

        XCTAssertEqual(query.accept(visitor: unencodedStringFormatter),
                       "{" +
                            "\n\tproducts {" +
                                "\n\t\tid" +
                            "\n\t}" +
                        "\n}")

        query.append(field: Field(name: "custom_collections", subFields: [Field(name: "id")]))

        XCTAssertEqual(query.accept(visitor: unencodedStringFormatter),
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

        XCTAssertEqual(query.accept(visitor: unencodedStringFormatter),
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

        XCTAssertEqual(query.accept(visitor: unencodedStringFormatter),
                       "query ProductList {" +
                            "\n\tproducts {" +
                                "\n\t\tid" +
                            "\n\t}" +
                        "\n}")

        query.append(variableDefinition: VariableDefinition(key: "count", type: "Int", value: .int(10)))

        XCTAssertEqual(query.accept(visitor: unencodedStringFormatter),
                       "query ProductList($count: Int) {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}" +
            "\n}")

        query.append(variableDefinitions: [
            VariableDefinition(key: "limit", type: "Int", value: .int(10)),
            VariableDefinition(key: "color", type: "Enum", value: .enumeration("blue"))
            ])

        XCTAssertEqual(query.accept(visitor: unencodedStringFormatter),
                       "query ProductList($count: Int, $limit: Int, $color: Enum) {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}" +
            "\n}")

        query.append(fields: [
            Field(name: "title"),
            Field(name: "name")
            ])

        XCTAssertEqual(query.accept(visitor: unencodedStringFormatter),
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

        XCTAssertEqual(mutation.accept(visitor: unencodedStringFormatter),
                       "mutation ProductList {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}" +
            "\n}")

        mutation.append(variableDefinition: VariableDefinition(key: "count", type: "Int", value: .int(10)))

        XCTAssertEqual(mutation.accept(visitor: unencodedStringFormatter),
                       "mutation ProductList($count: Int) {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}" +
            "\n}")

        mutation.append(variableDefinitions: [
            VariableDefinition(key: "limit", type: "Int", value: .int(10)),
            VariableDefinition(key: "color", type: "Enum", value: .enumeration("blue"))
            ])

        XCTAssertEqual(mutation.accept(visitor: unencodedStringFormatter),
                       "mutation ProductList($count: Int, $limit: Int, $color: Enum) {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}" +
            "\n}")

        mutation.append(fields: [
            Field(name: "title"),
            Field(name: "name")
            ])

        XCTAssertEqual(mutation.accept(visitor: unencodedStringFormatter),
                       "mutation ProductList($count: Int, $limit: Int, $color: Enum) {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}," +
                        "\n\ttitle," +
                        "\n\tname" +
            "\n}")
    }
}
