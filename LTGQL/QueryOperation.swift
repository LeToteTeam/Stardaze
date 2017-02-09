//
//  QueryOperation.swift
//  LTGQL
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public struct QueryOperation {
    internal var fields: [Field]
    internal var name: String?
    internal var variableDefinitions: [VariableDefinition]?

    public init(fields: [Field]) {
        self.fields = fields
        name = nil
        variableDefinitions = nil
    }

    public init(name: String, variableDefinitions: [VariableDefinition]? = nil, fields: [Field]) {
        self.name = name
        self.fields = fields
        self.variableDefinitions = variableDefinitions
    }

    public func userRepresentation() -> String {
        var finishedString = ""

        if let name = name {
            finishedString.append("query ")

            finishedString.append(name)

            if let variableDefinitions = variableDefinitions {
                finishedString.append("(")

                for (index, variableDefinition) in zip(0..<variableDefinitions.count, variableDefinitions) {
                    if index != 0 {
                        finishedString.append(", ")
                    }
                    finishedString.append(variableDefinition.userRepresentatin())
                }

                finishedString.append(")")
            }

            finishedString.append(" ")
        }

        finishedString.append("{\n")

        for (index, field) in zip(0..<fields.count, fields) {
            if index != 0 {
                finishedString.append(",")
                finishedString.append("\n")
            }

            finishedString.append(field.userRepresentation(depth: 1))
        }

        finishedString.append("\n}")

        return finishedString
    }
}
