//
//  Argument.swift
//  LTGQL
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public struct Argument {
    internal let key: String
    internal let value: CustomStringConvertible

    public init(key: String, value: CustomStringConvertible) {
        self.key = key
        self.value = value
    }

    public func userRepresentation() -> String {
        return "\(key): \(value)"
    }
}
