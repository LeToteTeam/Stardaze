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
    internal var fragments: [Fragment]?
    internal let queryOperation: QueryOperation
    internal let whitespaceRegexp: NSRegularExpression? = {
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
     Accepts a visitor
     */
    public func accept<T>(visitor: Visitor<T>) -> T {
        return visitor.visit(document: self)
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
}
