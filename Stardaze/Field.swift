//
//  Field.swift
//  Stardaze
//
//  Created by William Wilson on 2/7/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 Fields are used to specify the information that should appear in the response from the server. Specifying an alias will
 cause the information to be returned under that JSON field. Arguments are used to specify information used for
 filtering and sorting. Directives are used to specify conditions under which the field maybe included, skipped, or
 indicating that a field is deprecated. Fragments are used to pass in reusable sections of subfields. Subfields are
 used to specify what information should appear nested under the field.
 */
public struct Field {
    public typealias ExtendedGraphemeClusterLiteralType = String
    public typealias StringLiteralType = String
    public typealias UnicodeScalarLiteralType  = String
    internal let alias: String?
    internal var arguments: [Argument]?
    internal var directives: [Directive]?
    internal var fragments: [Fragment]?
    internal let name: String
    internal var subFields: [Field]?

    /**
     Required for the string literal convertible conformance.
     */
    public init(extendedGraphemeClusterLiteral value: Field.ExtendedGraphemeClusterLiteralType) {
        self.init(name: value)
    }

    /**
     The primary initializer
     
     - parameter name: The name of the field as used by the server.
     
     - parameter alias: The name that the field should appear under in the response.
     
     - parameter directives: The directives that should be applied to the field.
     
     - parameter subFields: The subFields that should appear under the field.
     
     - parameter fragments: Fragments that should appear under the field.
     */
    public init(name: String,
                alias: String? = nil,
                arguments: [Argument]? = nil,
                directives: [Directive]? = nil,
                subFields: [Field]? = nil,
                fragments: [Fragment]? = nil) {
        self.name = name
        self.alias = alias
        self.fragments = fragments
        self.arguments = arguments
        self.directives = directives
        self.subFields = subFields
    }

    /**
     The string literal initializer. This initializes a field with the name given by the literal.
     
     ```
     QueryOperation(fields: ["id"])
     ```
     
     - parameter stringLiteral: The name of the field.
     */
    public init(stringLiteral: Field.StringLiteralType) {
        self.init(name: stringLiteral)
    }

    /**
     Required for the string literal convertible conformance.
     */
    public init(unicodeScalarLiteral value: Field.UnicodeScalarLiteralType) {
        self.init(name: value)
    }

    /**
     Appends a single argument to the field.
     
     - parameter argument: The argument to appear on the field.
     */
    public mutating func append(argument: Argument) {
        guard let _ = arguments else {
            arguments = [argument]
            return
        }

        arguments?.append(argument)
    }

    /**
     Appends a single argument to a copy of the field and returns the copy.
     
     - parameter argument: The argument to appear on the field.
     
     - returns: A copy of the field.
     */
    public func appended(argument: Argument) -> Field {
        var copy = self

        copy.append(argument: argument)

        return copy
    }

    /**
     Appends multiple arguments to the field.
     
     - parameter arguments: The arguments to appear on the field.
     */
    public mutating func append(arguments: [Argument]) {
        guard let _ = self.arguments else {
            self.arguments = arguments
            return
        }

        self.arguments?.append(contentsOf: arguments)
    }

    /**
     Appends multiple arguments to a copy of the field and returns the copy.
     
     - parameter arguments: The arguments to appear on the field.
     
     - returns: A copy of the field.
     */
    public func appended(arguments: [Argument]) -> Field {
        var copy = self

        copy.append(arguments: arguments)

        return copy
    }

    /**
     Appends a directive to the field.
     
     - parameter directive: The directive to appear on the field.
     */
    public mutating func append(directive: Directive) {
        guard let _ = directives else {
            directives = [directive]
            return
        }

        directives?.append(directive)
    }

    /**
     Appends a directive to a copy of the field and returns the copy.
     
     - parameter directive: The directive to appear on the field.
     
     - returns: A copy of the field.
     */
    public func appended(directive: Directive) -> Field {
        var copy = self

        copy.append(directive: directive)

        return copy
    }

    /**
     Appends multiple directives to the field.
     
     - parameter directives: The directives to appear on the field.
     */
    public mutating func append(directives: [Directive]) {
        guard let _ = self.directives else {
            self.directives = directives
            return
        }

        self.directives?.append(contentsOf: directives)
    }

    /**
     Appends multiple directives to a copy of the field and returns the copy.
     
     - parameter directives: The directives to appear on the field.
     
     - returns: A copy of the field
     */
    public func appended(directives: [Directive]) -> Field {
        var copy = self

        copy.append(directives: directives)

        return copy
    }

    /**
     Appends a fragment to the field.
     
     - paramenter fragment: The fragment to appear on the field.
     */
    public mutating func append(fragment: Fragment) {
        guard let _ = fragments else {
            fragments = [fragment]
            return
        }

        fragments?.append(fragment)
    }

    /**
     Appends a fragment to a copy of the field and returns the copy.
     
     - paramenter fragment: The fragment to appear on the field.
     
     - returns: A copy of the field.
     */
    public func appended(fragment: Fragment) -> Field {
        var copy = self

        copy.append(fragment: fragment)

        return copy
    }

    /**
     Appends multiple fragments to the field.
     
     - parameter fragments: The fragments to appear on the field.
     */
    public mutating func append(fragments: [Fragment]) {
        guard let _ = self.fragments else {
            self.fragments = fragments
            return
        }

        self.fragments?.append(contentsOf: fragments)
    }

    /**
     Appends multiple fragments to a copy of the field and returns the copy.
     
     - parameter fragments: The fragments to appear on the field.
     
     - returns: A a copy of the field.
     */
    public func appended(fragments: [Fragment]) -> Field {
        var copy = self

        copy.append(fragments: fragments)

        return copy
    }

    /**
     Appends a subfield to the field.
     
     - parameter subField: The subfield to appear on the field.
     */
    public mutating func append(subField: Field) {
        guard let _ = subFields else {
            subFields = [subField]
            return
        }

        subFields?.append(subField)
    }

    /**
     Appends a subfield to a copy of the field and returns the copy.
     
     - parameter subField: The subfield to appear on the field.
     
     - returns: A copy of the field
     */
    public func appended(subField: Field) -> Field {
        var copy = self

        copy.append(subField: subField)

        return copy
    }

    /**
     Appends multiple subfields to the field.
     
     - parameter subFields: The subfields to appear on the field.
     */
    public mutating func append(subFields: [Field]) {
        guard let _ = self.subFields else {
            self.subFields = subFields
            return
        }

        self.subFields?.append(contentsOf: subFields)
    }

    /**
     Appends multiple subfields to a copy of the field and returns the copy.
     
     - parameter subFields: The subfields to appear on the field.
     
     - returns: A copy of the field.
     */
    public func appended(subFields: [Field]) -> Field {
        var copy = self

        copy.append(subFields: subFields)

        return copy
    }
}

extension Field: Receiver {
    internal func accept(visitor: Visitor) -> String {
        return visitor.visit(self)
    }
}

extension Field: ExpressibleByStringLiteral {}
