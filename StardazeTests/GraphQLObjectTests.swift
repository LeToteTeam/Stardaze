//
//  GraphQLObjectTests.swift
//  Stardaze
//
//  Created by William Wilson on 3/23/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

@testable import Stardaze
import XCTest

final class GraphQLObjectTests {
    let unencodedStringFormatter = UnencodedStringFormatter()

    func testStringFormatting() {
        XCTAssertEqual(GraphQLObject(["hello": "world"]).accept(visitor: unencodedStringFormatter), "{hello: \"world\"")
    }
}
