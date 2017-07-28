//
//  StringExtensionTests.swift
//  Stardaze
//
//  Created by William Wilson on 3/23/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

@testable import Stardaze
import XCTest

final class StringExtensionTests: XCTestCase {
    let unencodedStringFormatter = OutputFormatter(outputOption: .prettyPrinted)

    func testStringFormatting() {
        XCTAssertEqual("hello".accept(visitor: unencodedStringFormatter), "\"hello\"")
    }

    func testCondensingWhitespace() {
        let empty = ""
        let newEmpty = empty.condensingWhitespace()

        XCTAssertEqual(newEmpty, "")

        let singleSpace = " "
        let newSingleSpace = singleSpace.condensingWhitespace()

        XCTAssertEqual(newSingleSpace, " ")

        let noSpace = "HelloWorld"
        let newNoSpace = noSpace.condensingWhitespace()

        XCTAssertEqual(newNoSpace, "HelloWorld")

        let complexString = "\t\nHello \t\n\rWorld\r \t \n Foo\nBar\t "
        let newComplexString = complexString.condensingWhitespace()

        XCTAssertEqual(newComplexString, " Hello World Foo Bar ")

        let unicodeString = "😀\t\r\n✌️ \t😎"
        let newUnicodeString = unicodeString.condensingWhitespace()

        XCTAssertEqual(newUnicodeString, "😀 ✌️ 😎")
    }
}
