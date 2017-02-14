//
//  Argument.swift
//  LTGQL
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 Arguments are used to pass in additional information in fields related to filtering or sorting.
 */
public struct Argument {
    fileprivate let key: String
    fileprivate let value: Value

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

extension Argument: UserRepresentable {
    /**
     A stringified version of the argument. This is used internally and it may also be used for debugging.
     */
    public func userRepresentation() -> String {
        return "\(key): \(Value.extractString(value: value))"
    }
}
