//
//  QueryOperation.swift
//  LTGQL
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 QueryOperations are used to hold a set of fields and variable definitions. If a variable is going to be used in a field
 on the operation, it should be defined in a variable definition that is passed into the operation's
 variableDefinitions.
 */
public struct QueryOperation {
    private var fields: [Field]
    private var name: String?
    private var variableDefinitions: [VariableDefinition]?

    /**
     A secondary initializer for unnamed queries, which cannot contain variables.
     */
    public init(fields: [Field]) {
        self.fields = fields
        name = nil
        variableDefinitions = nil
    }

    /**
     The primary initializer.
     
     - parameter name: The name of the query.
     
     - parameter variableDefinitions: Definitions of all variables that will appear in fields listed under the 
     operation.
     
     - parameter fields: The fields that should appear on the operation.
     */
    public init(name: String, variableDefinitions: [VariableDefinition]? = nil, fields: [Field]) {
        self.name = name
        self.fields = fields
        self.variableDefinitions = variableDefinitions
    }

    /**
     Appends a single field to the operation.
     
     - parameter field: The field to appear on the operation.
     */
    public mutating func append(field: Field) {
        fields.append(field)
    }

    /**
     Appends multiple fields to the operation.
     
     - parameter fields: The fields to appear on the operation.
     */
    public mutating func append(fields: [Field]) {
        self.fields.append(contentsOf: fields)
    }

    /**
     Appends a variable definition to the operation.
     
     - parameter variableDefinition: The variable definition to appear on the operation.
     */
    public mutating func append(variableDefinition: VariableDefinition) {
        guard var variableDefinitions = variableDefinitions else {
            self.variableDefinitions = [variableDefinition]
            return
        }

        variableDefinitions.append(variableDefinition)
    }

    /**
     Appends multiple variable definitions to the operation.
     
     - parameter variableDefinitions: The variable definitions to appear on the operation.
     */
    public mutating func append(variableDefinitions: [VariableDefinition]) {
        guard let _ = self.variableDefinitions else {
            self.variableDefinitions = variableDefinitions
            return
        }

        self.variableDefinitions?.append(contentsOf: variableDefinitions)
    }

    /**
     A stringified version of the name of the operation. This is used internally and it may also be used for debugging.
     */
    public func nameRepresentation() -> String? {
        return name
    }

    /**
     A stringified version of the operation. This is used internally and it may also be used for debugging.
     */
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

    /**
     A stringified version of the values of the variables on the operation. This is used internally and it may also be
     used for debugging.
     */
    public func valueRepresentations() -> String? {
        guard let variableDefinitions = variableDefinitions, variableDefinitions.count >= 0 else {
            return nil
        }

        var finishedString = "{"

        for (index, variable) in zip(0..<variableDefinitions.count, variableDefinitions) {
            if index != 0 {
                finishedString.append(", ")
            }
            finishedString.append(variable.valueRepresentation())
        }

        finishedString.append("}")

        return finishedString
    }
}
