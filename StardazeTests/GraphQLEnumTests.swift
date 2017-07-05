//
//  GraphQLEnumTests.swift
//  Stardaze
//
//  Created by William Wilson on 3/22/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

@testable import Stardaze
import XCTest

final class GraphQLEnumTests {
    enum TestColor: String {
        case red
    }

    enum TestNum: String {
        case one
        case two
    }

    let unencodedStringFormatter = OutputFormatter(outputOption: .prettyPrinted, parameterize: false)

    func testStringFormatting() {
        XCTAssertEqual(GraphQLEnum(TestColor.red).accept(visitor: unencodedStringFormatter), "red")
        XCTAssertEqual(GraphQLEnum(TestNum.one).accept(visitor: unencodedStringFormatter), "one")
        XCTAssertEqual(GraphQLEnum(TestNum.two).accept(visitor: unencodedStringFormatter), "two")
    }
}
