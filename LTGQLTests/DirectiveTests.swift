//
//  DirectiveTests.swift
//  LTGQL
//
//  Created by William Wilson on 2/10/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

import LTGQL
import XCTest

final class DirectiveTests: XCTestCase {
    func testDeprecated() {
        XCTAssertEqual(Directive.deprecated(Variable("deprecationReason")).userRepresentation(),
                       "@deprecated(reason: $deprecationReason)")
    }

    func testInclude() {
        XCTAssertEqual(Directive.include(Variable("includeIf")).userRepresentation(),
                       "@include(if: $includeIf)")
    }

    func testSkip() {
        XCTAssertEqual(Directive.skip(Variable("skipIf")).userRepresentation(),
                       "@skip(if: $skipIf)")
    }
}
