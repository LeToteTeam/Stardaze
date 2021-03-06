//
//  GraphQLNullTests.swift
//  Stardaze
//
//  Created by William Wilson on 3/22/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

@testable import Stardaze
import XCTest

final class GraphQLNullTests: XCTestCase {
    let unencodedStringFormatter = OutputFormatter(outputOption: .prettyPrinted)

    func testStringFormatting() {
        XCTAssertEqual((nil as GraphQLNull).accept(visitor: unencodedStringFormatter), "null")
    }
}
