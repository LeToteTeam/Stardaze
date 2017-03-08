//
//  Value.swift
//  Stardaze
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 Values are used in arguments and variable definitions. At the time being, 64-bit integers
 are being used in this library despite the GraphQL spec specifying 32-bit integers.
 */
public enum Value {
    /**
     A boolean value.
     */
    case boolean(Bool)

    /**
     A double value
     */
    case double(Double)

    /**
     An enumerated value.
     */
    case enumeration(String)

    /**
     A 64-bit integer. The GraphQL spec requires 32-bit integers, so this may cause bugs in dealing with servers where
     the spec is followed strictly. The simplest solution is to override this class and use `Int32` instead.
     */
    case int(Int64)

    /**
     A list of other values.
     */
    indirect case list([Value])

    /**
     The null value
     */
    case null

    /**
     An object mapping strings to other values.
     */
    indirect case object([String: Value])

    /**
     A string.
     */
    case string(String)

    /**
     A variable. When using variables, the variable type definition must be given inside the document.
     */
    case variable(Variable)

    /**
     Accept a visitor.
     */
    public func accept<T>(visitor: Visitor<T>) -> T {
        return visitor.visit(value: self)
    }
}
