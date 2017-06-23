//
//  DirectiveTests.swift
//  Stardaze
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

@testable import Stardaze
import XCTest

final class DirectiveTests: XCTestCase {
    let stringFormatter = PrettyPrintedStringFormatter()
    func testDeprecated() {
        XCTAssertEqual(Directive.deprecated(Variable("deprecationReason")).accept(visitor: stringFormatter),
                       "@deprecated(reason: $deprecationReason)")
    }

    func testInclude() {
        XCTAssertEqual(Directive.include(Variable("includeIf")).accept(visitor: stringFormatter),
                       "@include(if: $includeIf)")
    }

    func testSkip() {
        XCTAssertEqual(Directive.skip(Variable("skipIf")).accept(visitor: stringFormatter),
                       "@skip(if: $skipIf)")
    }
}
