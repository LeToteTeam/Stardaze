//
//  Document.swift
//  Stardaze
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 The core GraphQL object. The encoded representation of a query operation should be obtained from this class after the
 query operation has been formed and all fragments have been added. A user readable representation may also be obtained
 from here.
 */
public struct Document {
    private var fragments: [Fragment]?
    private let queryOperation: QueryOperation
    private let whitespaceRegexp: NSRegularExpression? = {
        return try? NSRegularExpression(pattern: "[ \t\n]+", options: [])
    }()

    /**
     The primary initializer. The query operation should be fully formed before passing it in here.
     Fragments may be added after initialization.
     
     - parameter queryOperation: The operation that will be returned by the server. Although the GraphQL spec recognizes
        multiple operations, the description of how they will be treated is vague.
     
     - parameter fragments: The fragments that will form the description section of the document. All fragments that are
        used in the query operation should be included here.
     */
    public init(queryOperation: QueryOperation, fragments: [Fragment]? = nil) {
        self.queryOperation = queryOperation
        self.fragments = fragments
    }

    /**
     Appends a single fragment to be listed in the fragment definitions.
     
     - parameter fragment: The fragment to appear in the list.
     */
    public mutating func append(fragment: Fragment) {
        guard let _ = fragments else {
            fragments = [fragment]
            return
        }

        fragments?.append(fragment)
    }

    /**
     Appends multiple fragments to be listed in the fragment definitions.
     
     - parameter fragments: A list of fragments to appear in the list.
     */
    public mutating func append(fragments: [Fragment]) {
        guard let _ = self.fragments else {
            self.fragments = fragments
            return
        }
        self.fragments?.append(contentsOf: fragments)
    }

    /**
     A stringified version of the document. This string is human readable with spaces and tabs.
     */
    public func userRepresentation() -> String {
        var finishedString = queryOperation.userRepresentation()
        if let fragments = fragments, fragments.count > 0 {
            for fragment in fragments {
                finishedString.append("\n\n")
                finishedString.append(fragment.userDefinitionRepresentation())
            }
        }

        if let values = queryOperation.valueRepresentations() {
            finishedString.append("\n")

            finishedString.append(values)
        }

        return finishedString
    }

    /**
     A percent encoded representation of the document ready for placement in a url query.
     */
    public func encodedRepresentation() -> String {
        guard let regexp = whitespaceRegexp else {
            return ""
        }

        let transformedQuery = NSMutableString(string: userRepresentation().replacingOccurrences(of: ",", with: ""))

        regexp.replaceMatches(in: transformedQuery,
                              options: [],
                              range: transformedQuery.range(of: transformedQuery as String),
                              withTemplate: " ")

        guard let queryString = transformedQuery.addingPercentEncoding(withAllowedCharacters:
            CharacterSet.urlQueryAllowed) else {
            return ""
        }

        guard let operationName = queryOperation.nameRepresentation()?.addingPercentEncoding(withAllowedCharacters:
            CharacterSet.urlQueryAllowed),
            let variablesMinusCommas = queryOperation.valueRepresentations()?.replacingOccurrences(of: ",",
                                                                                                   with: "") else {
            return "query=\(queryString)"
        }

        let transformedVariables = NSMutableString(string: variablesMinusCommas)

        regexp.replaceMatches(in: transformedVariables,
                              options: [],
                              range: transformedVariables.range(of: transformedVariables as String),
                              withTemplate: " ")

        guard let variablesString =
            transformedVariables.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return "query=\(queryString)"
        }

        return "query=\(queryString)&operationName=\(operationName)&variables=\(variablesString)"
    }
}
