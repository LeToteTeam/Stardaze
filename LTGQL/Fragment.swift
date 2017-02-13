//
//  Fragment.swift
//  LTGQL
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public struct Fragment {
    private var fields: [Field]
    private let name: String
    private let type: String

    public init(name: String, type: String, fields: [Field]) {
        self.name = name
        self.type = type
        self.fields = fields
    }

    public mutating func append(field: Field) {
        fields.append(field)
    }

    public mutating func append(fields: [Field]) {
        self.fields.append(contentsOf: fields)
    }

    public func userRepresentation(depth: Int) -> String {
        var finishedString = ""

        for _ in 0..<depth {
            finishedString.append("\t")
        }

        finishedString.append("...\(name)")

        return finishedString
    }

    public func userDefinitionRepresentation() -> String {
        var finishedString = ""

        finishedString.append("fragment \(name) on \(type) {\n")

        for field in fields {
            finishedString.append(field.userRepresentation(depth: 1))
            finishedString.append("\n")
        }

        finishedString.append("}")

        return finishedString
    }
}
