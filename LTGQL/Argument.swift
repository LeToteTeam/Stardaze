//
//  Argument.swift
//  LTGQL
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public struct Argument {
    fileprivate let key: String
    fileprivate let value: Value

    public init(key: String, value: Value) {
        self.key = key
        self.value = value
    }
}

extension Argument: UserRepresentable {
    public func userRepresentation() -> String {
        return "\(key): \(Value.extractString(value: value))"
    }
}
