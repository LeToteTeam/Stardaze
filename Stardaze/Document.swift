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
    private let compactParametersFormatter = OutputFormatter(outputOption: .compact)
    private let compactStringFormatter = OutputFormatter(outputOption: .compact)
    private let encodedParametersFormatter = OutputFormatter(outputOption: .encoded)
    private let encodedStringFormatter = OutputFormatter(outputOption: .encoded)
    internal var fragments: [Fragment]?
    internal let queryOperation: QueryOperation
    private let unencodedParametersFormatter = OutputFormatter(outputOption: .prettyPrinted)
    private let unecodedStringFormatter = OutputFormatter(outputOption: .prettyPrinted)

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
     Appends a single fragment to be listed in the fragment definitions on to a copy
     of the document and returns the copy.
     
     - parameter fragment: The fragment to appear in the list.
     
     - returns: A copy of the document.
     */
    public func appended(fragment: Fragment) -> Document {
        var copy = self

        copy.append(fragment: fragment)

        return copy
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
     Appends multiple fragments to be listed in the fragment definitions to a copy of the document and returns the copy.
     
     - parameter fragments: A list of fragments to appear in the list.
     
     - returns: A copy of the document.
     */
    public func appended(fragments: [Fragment]) -> Document {
        var copy = self

        copy.append(fragments: fragments)

        return copy
    }

    /**
     Returns a parameters dictionary with the required key query and the optional keys operationName and variables if
     they apply.
     
     - parameter encoded: Indicates whether the value strings should be percent encoded.
     
     - returns: A parameters dictionary.
     */
    public func parameterize(format: OutputOption) -> [String: Any] {
        switch format {
        case .compact:
            return compactParametersFormatter.visit(self)

        case .encoded:
            return encodedParametersFormatter.visit(self)

        case .prettyPrinted:
            return unencodedParametersFormatter.visit(self)
        }
    }

    /**
     Returns either a readable string or a percent encoded string.
     
     - parameter encoded: Indicates whether the return value should be percent encoded.
     
     - returns: A string representation of the document.
     */
    public func stringify(format: OutputOption) -> String {
        switch format {
        case .compact:
            return compactStringFormatter.visit(self)

        case .encoded:
            return encodedStringFormatter.visit(self)

        case .prettyPrinted:
            return unecodedStringFormatter.visit(self)
        }
    }
}
