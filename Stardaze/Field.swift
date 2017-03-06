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
    private let alias: String?
    private var arguments: [Argument]?
    private var directives: [Directive]?
    private var fragments: [Fragment]?
    private let name: String
    private var subFields: [Field]?

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
     A stringified version of the field. This is used internally and it may also be used for debugging.
     */
    public func userRepresentation(depth: Int) -> String {
        var finishedString = ""

        for _ in 0..<depth {
            finishedString.append("\t")
        }

        if let alias = alias {
            finishedString.append("\(alias): ")
        }

        finishedString.append(name)

        if let arguments = arguments, arguments.count > 0 {
            finishedString.append("(")
            finishedString.append(arguments.userRepresentation())
            finishedString.append(")")
        }

        if let directives = directives {
            finishedString.append(" ")
            finishedString.append(directives.userRepresentation())
        }

        if subFields != nil || fragments != nil {
            finishedString.append(" {\n")

            if let subFields = subFields {
                for field in subFields {
                    finishedString.append(field.userRepresentation(depth: depth + 1))
                    finishedString.append("\n")
                }
            }

            if let fragments = fragments {
                for fragment in fragments {
                    finishedString.append(fragment.userRepresentation(depth: depth + 1))
                    finishedString.append("\n")
                }
            }

            for _ in 0..<depth {
                finishedString.append("\t")
            }

            finishedString.append("}")
        }

        return finishedString
    }
}
