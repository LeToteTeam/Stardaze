//
//  DirectiveTests.swift
//  Stardaze
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

import Stardaze
import XCTest

final class DirectiveTests: XCTestCase {
    let readablePrinter = ReadablePrinter()
    func testDeprecated() {
        XCTAssertEqual(Directive.deprecated(Variable("deprecationReason")).accept(visitor: readablePrinter),
                       "@deprecated(reason: $deprecationReason)")
    }

    func testInclude() {
        XCTAssertEqual(Directive.include(Variable("includeIf")).accept(visitor: readablePrinter),
                       "@include(if: $includeIf)")
    }

    func testSkip() {
        XCTAssertEqual(Directive.skip(Variable("skipIf")).accept(visitor: readablePrinter),
                       "@skip(if: $skipIf)")
    }
}
