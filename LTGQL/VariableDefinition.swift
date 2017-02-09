//
//  VariableDefinition.swift
//  LTGQL
//
//  Created by William Wilson on 2/9/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public struct VariableDefinition {
    internal let key: String
    internal let type: String

    public init(key: String, type: String) {
        self.key = key
        self.type = type
    }

    public func userRepresentatin() -> String {
        return "$\(key): \(type)"
    }
}
