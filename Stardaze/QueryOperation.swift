//
//  QueryOperation.swift
//  Stardaze
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
    internal var fields: [Field]
    internal var mutating: Bool
    internal var name: String?
    internal var variableDefinitions: [VariableDefinition]?

    /**
     A secondary initializer for unnamed queries, which cannot contain variables.
     */
    public init(mutating: Bool = false, fields: [Field]) {
        self.fields = fields
        self.mutating = mutating
        name = nil
        variableDefinitions = nil
    }

    /**
     The primary initializer.
     
     - parameter name: The name of the query.
     - parameter mutating: Specifies that the operation is a mutation.
     - parameter variableDefinitions: Definitions of all variables that will appear in fields listed under the 
     operation.
     
     - parameter fields: The fields that should appear on the operation.
     */
    public init(name: String,
                variableDefinitions: [VariableDefinition]? = nil,
                mutating: Bool = false,
                fields: [Field]) {
        self.name = name
        self.mutating = mutating
        self.fields = fields
        self.variableDefinitions = variableDefinitions
    }

    /**
     Accepts a visitor.
     */
    public func accept<T>(visitor: Visitor<T>) -> T {
        return visitor.visit(queryOperation: self)
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
}
