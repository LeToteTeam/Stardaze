//
//  Argument.swift
//  Stardaze
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 Arguments are used to pass in additional information in fields, typically related to filtering or sorting.
 */
public struct Argument {
    internal let key: String
    internal let value: Value

    /**
     The primary initialzer.
     
     - parameter key: The name of the argument.
     
     - parameter value: The value that the argument should take.
     */
    public init(key: String, value: Value) {
        self.key = key
        self.value = value
    }
}

extension Argument: Receiver {
    /**
     Accept a visitor
     */
    public func accept<T>(visitor: Visitor<T>) -> T {
        return visitor.visit(self)
    }
}
