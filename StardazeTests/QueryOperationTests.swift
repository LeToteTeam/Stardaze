//
//  QueryOperationTests.swift
//  Stardaze
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

@testable import Stardaze
import XCTest

final class QueryOperationTests: XCTestCase {
    enum TestEnum: String {
        case blue
    }

    let unencodedStringFormatter = OutputFormatter(outputOption: .prettyPrinted, parameterize: false)
    func testUnnamed() {
        let query = QueryOperation(fields: [Field(name: "products", subFields: ["id"])])

        XCTAssertEqual(query.accept(visitor: unencodedStringFormatter),
                       "{" +
                            "\n\tproducts {" +
                                "\n\t\tid" +
                            "\n\t}" +
                        "\n}")

        let withCollections = query.appended(field: Field(name: "custom_collections", subFields: ["id"]))

        XCTAssertEqual(withCollections.accept(visitor: unencodedStringFormatter),
                       "{" +
                            "\n\tproducts {" +
                                "\n\t\tid" +
                            "\n\t}" +
                            "\n\tcustom_collections {" +
                                "\n\t\tid" +
                            "\n\t}" +
                        "\n}")

        let withTitle = withCollections.appended(fields: ["title", "name"])

        XCTAssertEqual(withTitle.accept(visitor: unencodedStringFormatter),
                       "{" +
                            "\n\tproducts {" +
                                "\n\t\tid" +
                            "\n\t}" +
                            "\n\tcustom_collections {" +
                                "\n\t\tid" +
                            "\n\t}" +
                            "\n\ttitle" +
                            "\n\tname" +
                        "\n}")
    }

    func testNamed() {
        let query = QueryOperation(name: "ProductList",
                                   fields: [Field(name: "products", subFields: ["id"])])

        XCTAssertEqual(query.accept(visitor: unencodedStringFormatter),
                       "query ProductList {" +
                            "\n\tproducts {" +
                                "\n\t\tid" +
                            "\n\t}" +
                        "\n}")

        let withCount = query.appended(variableDefinition: VariableDefinition(key: "count",
                                                                              type: "Int",
                                                                              value: 10))

        XCTAssertEqual(withCount.accept(visitor: unencodedStringFormatter),
                       "query ProductList($count: Int) {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}" +
            "\n}")

        let withLimit = withCount.appended(variableDefinitions: [
            VariableDefinition(key: "limit", type: "Int", value: 10),
            VariableDefinition(key: "color", type: "Enum", value: TestEnum.blue)
            ])

        XCTAssertEqual(withLimit.accept(visitor: unencodedStringFormatter),
                       "query ProductList($count: Int, $limit: Int, $color: Enum) {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}" +
            "\n}")

        let withTitle = withLimit.appended(fields: ["title", "name"])

        XCTAssertEqual(withTitle.accept(visitor: unencodedStringFormatter),
                       "query ProductList($count: Int, $limit: Int, $color: Enum) {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}" +
                        "\n\ttitle" +
                        "\n\tname" +
            "\n}")
    }

    func testMutation() {
        let mutation = QueryOperation(name: "ProductList",
                                      mutating: true,
                                      fields: [Field(name: "products", subFields: ["id"])])

        XCTAssertEqual(mutation.accept(visitor: unencodedStringFormatter),
                       "mutation ProductList {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}" +
            "\n}")

        let withCount = mutation.appended(variableDefinition: VariableDefinition(key: "count",
                                                                                 type: "Int",
                                                                                 value: 10))

        XCTAssertEqual(withCount.accept(visitor: unencodedStringFormatter),
                       "mutation ProductList($count: Int) {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}" +
            "\n}")

        let withLimit = withCount.appended(variableDefinitions: [
            VariableDefinition(key: "limit", type: "Int", value: 10),
            VariableDefinition(key: "color", type: "Enum", value: TestEnum.blue)
            ])

        XCTAssertEqual(withLimit.accept(visitor: unencodedStringFormatter),
                       "mutation ProductList($count: Int, $limit: Int, $color: Enum) {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}" +
            "\n}")

        let withTitle = withLimit.appended(fields: ["title", "name"])

        XCTAssertEqual(withTitle.accept(visitor: unencodedStringFormatter),
                       "mutation ProductList($count: Int, $limit: Int, $color: Enum) {" +
                        "\n\tproducts {" +
                        "\n\t\tid" +
                        "\n\t}" +
                        "\n\ttitle" +
                        "\n\tname" +
            "\n}")
    }
}
