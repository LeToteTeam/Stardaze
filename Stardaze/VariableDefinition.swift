//
//  VariableDefinition.swift
//  Stardaze
//
//  Created by William Wilson on 2/9/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 VariableDefinitions are passed onto a query operation so that variables with the same name may be used in fields on
 the query operation.
 */
public struct VariableDefinition {
    internal let key: String
    internal let notNullable: Bool
    internal let type: String
    internal let value: Value

    /**
     The primary initializer.
     
     - parameter key: The name of the variable.
     
     - parameter type: The type of the variable.
     
     - parameter notNullable: The variable may be specified as nonNullable.
     
     - parameter value: The value that the variable should take.
     */
    public init(key: String, type: String, notNullable: Bool = false, value: Value) {
        self.key = key
        self.type = type
        self.notNullable = notNullable
        self.value = value
    }

    /**
     Accept a visitor
     */
    public func accept<T>(visitor: Visitor<T>) -> T {
        return visitor.visit(variableDefinition: self)
    }
}
