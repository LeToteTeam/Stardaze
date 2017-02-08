//
//  Query.swift
//  LTGQL
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public struct Query {
    internal var fields: [Field]
    internal var fragments: [Fragment]?

    public init(fields: [Field], fragments: [Fragment]? = nil) {
        self.fields = fields
        self.fragments = fragments
    }

    public func userRepresentation() -> String {
        var finishedString = "{\n"
        for (index, field) in zip(0..<fields.count, fields) {
            if index != 0 {
                finishedString.append(",")
                finishedString.append("\n")
            }
            finishedString.append(field.userRepresentation(depth: 1))
        }
        finishedString.append("\n}")

        if let fragments = fragments {
            for fragment in fragments {
                finishedString.append("\n\n")
                finishedString.append(fragment.userDefinitionRepresentation())
            }
        }
        return finishedString
    }

    // Percent escapes values as specified in RFC 3986, https://tools.ietf.org/html/rfc2396#page-9
    // Although the algorithm used to escape is an Apple black box, https://github.com/apple/swift
    // it should behave similarly to https://en.wikipedia.org/wiki/Percent-encoding 
    // one notable difference being that Apple does not use '+' but rather %20 for ' '.
    public func serverRepresentation() -> String? {
        let allowedCharacters = CharacterSet(charactersIn:
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return userRepresentation().addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
}
