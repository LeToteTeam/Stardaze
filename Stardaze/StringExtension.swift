//
//  StringExtension.swift
//  Stardaze
//
//  Created by William Wilson on 3/22/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

internal extension String {
    private var whitespaceRegexp: NSRegularExpression {
        return try! NSRegularExpression(pattern: "[ \t\n\r]+", options: [])
    }

    internal func condensingWhitespace() -> String {
        let start = self.utf16.startIndex
        let end = self.utf16.endIndex
        let distance = start.distance(to: end)
        let range = NSRange(location: 0, length: distance)

        return whitespaceRegexp.stringByReplacingMatches(in: self,
                                                         options: [],
                                                         range: range,
                                                         withTemplate: " ")
    }

    internal func urlEncoded() -> String {
        let copy = self

        return copy.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? copy
    }
}

extension String: Receiver {
    internal func accept(visitor: Visitor) -> String {
        return visitor.visit(self)
    }
}
