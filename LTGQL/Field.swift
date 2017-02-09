//
//  Field.swift
//  LTGQL
//
//  Created by William Wilson on 2/7/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public struct Field {
    internal let name: String
    internal let alias: String?
    internal let fragment: Fragment?
    internal var arguments: [Argument]?
    internal var subFields: [Field]?

    public init(name: String, alias: String? = nil, arguments: [Argument]? = nil, subFields: [Field]? = nil) {
        self.name = name
        self.alias = alias
        self.fragment = nil
        self.arguments = arguments
        self.subFields = subFields
    }

    public init(name: String, alias: String? = nil, arguments: [Argument]? = nil, fragment: Fragment?) {
        self.name = name
        self.fragment = fragment
        self.alias = alias
        self.arguments = arguments
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
            for (index, argument) in zip(0..<arguments.count, arguments) {
                if index != 0 {
                    finishedString.append(", ")
                }

                finishedString.append(argument.userRepresentation())
            }

            finishedString.append(")")
        }

        if let fragment = fragment {
            finishedString.append(" {\n")
            finishedString.append(fragment.userRepresentation(depth: depth + 1))

            finishedString.append("\n")

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
