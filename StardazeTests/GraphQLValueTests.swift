//
//  GraphQLValueListTests.swift
//  Stardaze
//
//  Created by William Wilson on 3/22/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

@testable import Stardaze
import XCTest

final class GraphQLListTests: XCTestCase {
    enum TestEnum: String {
        case blue
    }

    let unencodedStringFormatter = UnencodedStringFormatter()

    func testStringRepresentation() {
        XCTAssertEqual(GraphQLList([
            1,
            0.5,
            "hello",
            GraphQLEnum(TestEnum.blue)]).accept(visitor: unencodedStringFormatter), "[1, 0.5, \"hello\", blue]")
    }
}
