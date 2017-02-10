//
//  LTGQLTests.swift
//  LTGQLTests
//
//  Created by William Wilson on 2/7/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

import XCTest
@testable import LTGQL

class LTGQLTests: XCTestCase {
    lazy var basicDocument: Document = {
        let query = QueryOperation(fields: [
                self.productField,
                Field(name: "custom_collections",
                      arguments: nil,
                      subFields: [
                        Field(name: "count")
                    ])
                ])
        return Document(queryOperation: query)
    }()

    lazy var documentWithDirectives: Document = {
        let query = QueryOperation(fields: [self.fieldWithDirectives])

        return Document(queryOperation: query)
    }()

    let fieldWithDirectives = Field(name: "products",
                                    arguments: nil,
                                    directives: [.skip(Variable("withProducts"))
        ],
                                    subFields: [Field(name: "id"),
                                                Field(name: "type"),
                                                Field(name: "customer_photos",
                                                      alias: "customerPhotos",
                                                      arguments: [
                                                        Argument(key: "limit", value: .int(10))],
                                                      directives: [
                                                        .skip(Variable("skipPhotos")),
                                                        .include(Variable("showPhotos"))],
                                                      subFields: [
                                                        Field(name: "id"),
                                                        Field(name: "size")
                                                    ])
        ])

    lazy var fragmentDocument: Document = {
        guard let subFields = self.productField.subFields else {
            XCTFail()
            fatalError()
        }

        let fragment1 = Fragment(name: "productFields", type: "Product", fields: subFields)
        let fragment2 = Fragment(name: "productAdditionalFields", type: "Product", fields: [Field(name: "snow")])
        let query = QueryOperation(fields: [
                Field(name: "products", alias: "productList", arguments: [
                    Argument(key: "maternity", value: .boolean(false)),
                    Argument(key: "filter_terms", value: .enumeration("pants")),
                    Argument(key: "ids", value: .list([.int(1), .int(2)]))
                    ],
                      directives: nil,
                      fragments: [fragment1, fragment2])
                ])

        return Document(queryOperation: query, fragments: [fragment1, fragment2])
    }()

    lazy var namedQueryOperationDocument: Document = {
        let query = QueryOperation(name: "ProductList",
                                   variableDefinitions: [
                                    VariableDefinition(key: "limit", type: "Int"),
                                    VariableDefinition(key: "color", type: "Color")
            ],
                                   fields: [
                                    Field(name: "products",
                                          alias: "productList",
                                          arguments: [
                                            Argument(key: "limit", value: .variable(Variable("limit")))
                                        ],
                                          subFields: [
                                            Field(name: "id"),
                                            Field(name: "title")
                                        ])
            ])

        return Document(queryOperation: query)
    }()

    let productField = Field(name: "products",
                             alias: "productList",
                             arguments: [
                                Argument(key: "maternity", value: .boolean(false)),
                                Argument(key: "filter_terms", value: .enumeration("pants")),
                                Argument(key: "string", value: .string("something")),
                                Argument(key: "options", value: .object(["size":.string("small")]))
                            ],
                             directives: nil,
                             subFields: [
                                Field(name: "id"),
                                Field(name: "type"),
                                Field(name: "title"),
                                Field(name: "title",
                                      alias: "aliasedTitle"),
                                Field(name: "customer_photos",
                                      alias: "customerPhotos",
                                      arguments: [
                                        Argument(key: "limit", value: .int(10))
                                    ], subFields: [
                                        Field(name: "customer_name")
                                    ])
        ])

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testBasicQuery() {
        XCTAssertEqual(basicDocument.userRepresentation(), "{" +
            "\n\tproductList: products(maternity: false, filter_terms: pants, " +
            "string: \"something\", options: {size: \"small\"}) {" +
                "\n\t\tid" +
                "\n\t\ttype" +
                "\n\t\ttitle" +
                "\n\t\taliasedTitle: title" +
                "\n\t\tcustomerPhotos: customer_photos(limit: 10) {" +
                    "\n\t\t\tcustomer_name" +
                "\n\t\t}" +
            "\n\t}," +
            "\n\tcustom_collections {" +
                "\n\t\tcount" +
            "\n\t}" +
    "\n}")
    }

    func testFieldsWithDirectives() {
        XCTAssertEqual(documentWithDirectives.userRepresentation(), "{" +
            "\n\tproducts @skip(if: $withProducts) {" +
                "\n\t\tid" +
                "\n\t\ttype" +
                "\n\t\tcustomerPhotos: customer_photos(limit: 10) @skip(if: $skipPhotos), @include(if: $showPhotos) {" +
                    "\n\t\t\tid" +
                    "\n\t\t\tsize" +
                "\n\t\t}" +
            "\n\t}" +
        "\n}")
    }

    func testFragmentQuery() {
        XCTAssertEqual(fragmentDocument.userRepresentation(), "{" +
            "\n\tproductList: products(maternity: false, filter_terms: pants, ids: [1,2]) {" +
                "\n\t\t...productFields" +
                "\n\t\t...productAdditionalFields" +
            "\n\t}" +
        "\n}" +
        "\n" +
        "\nfragment productFields on Product {" +
            "\n\tid" +
            "\n\ttype" +
            "\n\ttitle" +
            "\n\taliasedTitle: title" +
            "\n\tcustomerPhotos: customer_photos(limit: 10) {" +
                "\n\t\tcustomer_name" +
            "\n\t}" +
        "\n}" +
        "\n" +
        "\nfragment productAdditionalFields on Product {" +
            "\n\tsnow" +
        "\n}")
    }

    func testNamedQuery() {
        XCTAssertEqual(namedQueryOperationDocument.userRepresentation(), "query " +
            "ProductList($limit: Int, $color: Color) {" +
                "\n\tproductList: products(limit: $limit) {" +
                    "\n\t\tid" +
                    "\n\t\ttitle" +
                "\n\t}" +
            "\n}")
    }

    func testPerformanceBasicDocument() {
        measure {
            let _ = self.basicDocument.serverRepresentation()
        }
    }

    func testPerformanceFragmentDocument() {
        measure {
            let _ = self.fragmentDocument.serverRepresentation()
        }
    }

    func testPerformanceNamedQueryDocument() {
        measure {
            let _ = self.namedQueryOperationDocument.serverRepresentation()
        }
    }

    func testServerRepresentation() {
        guard let serverRepresentation = fragmentDocument.serverRepresentation() else {
            XCTFail()
            fatalError()
        }

        XCTAssertFalse(serverRepresentation.contains(" \t\n"))
    }
}
