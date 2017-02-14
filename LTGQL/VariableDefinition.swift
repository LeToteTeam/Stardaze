//
//  VariableDefinition.swift
//  LTGQL
//
//  Created by William Wilson on 2/9/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 VariableDefinitions are passed onto a query operation so that variables with the same name may be used in fields on
 the query operation.
 */
public struct VariableDefinition {
    fileprivate let key: String
    fileprivate let notNullable: Bool
    fileprivate let type: String
    private let value: Value

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
     A stringified version of the value of the variable. This is used internally and it may also be used for debugging.
     */
    public func valueRepresentation() -> String {
        return "\"\(key)\": \(Value.extractString(value: value))"
    }
}

extension VariableDefinition: UserRepresentable {
    /**
     A stringified version of the definition of the variable. This is used internally and it may also be used for
     debugging.
     */
    public func userRepresentation() -> String {
        return "$\(key): \(type)\(notNullable ? "!" : "")"
    }
}
