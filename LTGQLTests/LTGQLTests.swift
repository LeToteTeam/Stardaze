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

    lazy var fragmentQuery: Query = {
        guard let subFields = self.productField.subFields else {
            XCTFail()
            fatalError()
        }

        let fragment = Fragment(name: "productFields", type: "Product", fields: subFields)

        return Query(fields: [
            Field(name: "products", fragment: fragment, alias: "productList", arguments: [
                Argument(key: "maternity", value: "false"),
                Argument(key: "filter_terms", value: "pants")
                ])
            ],
                     fragments: [
                        fragment
            ])
    }()

    lazy var basicQuery: Query = {
        Query(fields: [
            self.productField,
            Field(name: "custom_collections",
                  arguments: nil,
                  subFields: [
                    Field(name: "count")
                ])
            ])
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
        XCTAssertEqual(basicQuery.userRepresentation(), "{" +
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
        XCTAssertEqual(fragmentQuery.userRepresentation(), "{" +
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

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
