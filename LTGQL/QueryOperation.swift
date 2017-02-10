//
//  QueryOperation.swift
//  LTGQL
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public struct QueryOperation {
    private var fields: [Field]
    private var name: String?
    private var variableDefinitions: [VariableDefinition]?

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

    public mutating func append(field: Field) {
        fields.append(field)
    }

    public mutating func append(variableDefinition: VariableDefinition) {
        guard var variableDefinitions = variableDefinitions else {
            self.variableDefinitions = [variableDefinition]
            return
        }

        variableDefinitions.append(variableDefinition)
    }

    public func userRepresentation() -> String {
        var finishedString = ""

        if let name = name {
            finishedString.append("query ")

            finishedString.append(name)

            if let variableDefinitions = variableDefinitions {
                finishedString.append("(")
                finishedString.append(variableDefinitions.userRepresentation())
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
