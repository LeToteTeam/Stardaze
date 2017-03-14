//
//  NSMutableStringExtension.swift
//  Stardaze
//
//  Created by William Wilson on 3/14/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

internal extension NSMutableString {
    var whitespaceRegexp: NSRegularExpression {
        return try! NSRegularExpression(pattern: "[ \t\n]+", options: [])
    }

    func condenseWhitespace() {
        // NSString.range(of:) returns nil for the empty string causing a crash
        if !String(self).isEmpty {
            whitespaceRegexp.replaceMatches(in: self,
                                            options: [],
                                            range: self.range(of: self as String), withTemplate: " ")
        }
    }
}
