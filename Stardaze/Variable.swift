//
//  Variable.swift
//  Stardaze
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 Variables are a type of value. Every variable should have a matching variable definition on the QueryOperator which
 it is related to.
 */
public struct Variable {
    internal let key: String

    /**
     The primary initializer.
     
     - parameter key: The name of the variable
     */
    public init(_ key: String) {
        self.key = key
    }
}
