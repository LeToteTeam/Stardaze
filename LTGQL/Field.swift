//
//  Field.swift
//  LTGQL
//
//  Created by William Wilson on 2/7/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public struct Field {
    internal let alias: String?
    internal var arguments: [Argument]?
    internal var directives: [Directive]?
    internal let fragments: [Fragment]?
    internal let name: String
    internal var subFields: [Field]?

    public init(name: String,
                alias: String? = nil,
                arguments: [Argument]? = nil,
                directives: [Directive]? = nil,
                subFields: [Field]? = nil) {
        self.name = name
        self.alias = alias
        self.fragments = nil
        self.arguments = arguments
        self.directives = directives
        self.subFields = subFields
    }

    public init(name: String,
                alias: String? = nil,
                arguments: [Argument]? = nil,
                directives: [Directive]? = nil,
                fragments: [Fragment]?) {
        self.name = name
        self.fragments = fragments
        self.alias = alias
        self.arguments = arguments
        self.directives = directives
        self.subFields = nil
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

        if let fragments = fragments {
            finishedString.append(" {\n")

            for fragment in fragments {
                finishedString.append(fragment.userRepresentation(depth: depth + 1))
                finishedString.append("\n")
            }

            for _ in 0..<depth {
                finishedString.append("\t")
            }

            finishedString.append("}")
        } else if let subFields = subFields, subFields.count > 0 {
            finishedString.append(" {\n")
            for field in subFields {
                finishedString.append(field.userRepresentation(depth: depth + 1))
                finishedString.append("\n")
            }

            for _ in 0..<depth {
                finishedString.append("\t")
            }

            finishedString.append("}")
        }

        return finishedString
    }
}
