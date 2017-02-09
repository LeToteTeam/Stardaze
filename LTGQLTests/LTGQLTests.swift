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
    let productField = Field(name: "products",
                             alias: "productList",
                             arguments: [
                                Argument(key: "maternity", value: "false"),
                                Argument(key: "filter_terms", value: "pants")
                            ], subFields: [
                                Field(name: "id"),
                                Field(name: "type"),
                                Field(name: "title"),
                                Field(name: "title",
                                      alias: "aliasedTitle"),
                                Field(name: "customer_photos",
                                      alias: "customerPhotos",
                                      arguments: [
                                        Argument(key: "limit", value: 10)
                                    ], subFields: [
                                        Field(name: "customer_name")
                                    ])
        ])

    lazy var fragmentDocument: Document = {
        guard let subFields = self.productField.subFields else {
            XCTFail()
            fatalError()
        }

        let fragment = Fragment(name: "productFields", type: "Product", fields: subFields)
        let query = QueryOperation(fields: [
                Field(name: "products", fragment: fragment, alias: "productList", arguments: [
                    Argument(key: "maternity", value: "false"),
                    Argument(key: "filter_terms", value: "pants")
                    ])
                ])

        return Document(queryOperation: query, fragments: [fragment])
    }()

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

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBasicQuery() {
        XCTAssertEqual(basicDocument.userRepresentation(), "{" +
            "\n\tproductList: products(maternity: false, filter_terms: pants) {" +
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

    func testFragmentQuery() {
        XCTAssertEqual(fragmentDocument.userRepresentation(), "{" +
            "\n\tproductList: products(maternity: false, filter_terms: pants) {" +
                "\n\t\t...productFields" +
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
        "\n}")
    }

    func testServerRepresentation() {
        guard let serverRepresentation = fragmentDocument.serverRepresentation() else {
            XCTFail()
            fatalError()
        }

        XCTAssertFalse(serverRepresentation.contains(" \t\n"))
    }

    func testPerformanceExample() {
        self.measure {
            let _ = self.fragmentDocument.serverRepresentation()
        }
    }

}
