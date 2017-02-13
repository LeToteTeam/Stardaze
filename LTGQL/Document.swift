//
//  Document.swift
//  LTGQL
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public struct Document {
    private var fragments: [Fragment]?

    // TODO: The spec is vague about how to handle multiple queries as of October 2016, 
    // https://github.com/facebook/graphql/tree/master/spec
    // When this is updated in the spec and the implementations begin to support it,
    // we will need to add support as well.
    private let queryOperation: QueryOperation

    public init(queryOperation: QueryOperation, fragments: [Fragment]? = nil) {
        self.queryOperation = queryOperation
        self.fragments = fragments
    }

    public mutating func append(fragment: Fragment) {
        guard let _ = fragments else {
            fragments = [fragment]
            return
        }

        fragments?.append(fragment)
    }

    public mutating func append(fragments: [Fragment]) {
        guard let _ = self.fragments else {
            self.fragments = fragments
            return
        }
        self.fragments?.append(contentsOf: fragments)
    }

    public func userRepresentation() -> String {
        var finishedString = queryOperation.userRepresentation()
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
    public func encodedRepresentation() -> String {
        let allowedCharacters = CharacterSet(charactersIn:
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")

        guard let string = userRepresentation().addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            return ""
        }

        return string
    }
}
