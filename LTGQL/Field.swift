//
//  Field.swift
//  LTGQL
//
//  Created by William Wilson on 2/7/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public struct Field {
    private let alias: String?
    private var arguments: [Argument]?
    private var directives: [Directive]?
    private var fragments: [Fragment]?
    private let name: String
    private var subFields: [Field]?

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

    public mutating func append(argument: Argument) {
        guard let _ = arguments else {
            arguments = [argument]
            return
        }

        arguments?.append(argument)
    }

    public mutating func append(directive: Directive) {
        guard let _ = directives else {
            directives = [directive]
            return
        }

        directives?.append(directive)
    }

    public mutating func append(fragment: Fragment) {
        guard let _ = fragments else {
            fragments = [fragment]
            return
        }

        fragments?.append(fragment)
    }

    public mutating func append(subField: Field) {
        guard let _ = subFields else {
            subFields = [subField]
            return
        }

        subFields?.append(subField)
    }

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
