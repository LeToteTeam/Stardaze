//
//  VariableDefinition.swift
//  LTGQL
//
//  Created by William Wilson on 2/9/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public struct VariableDefinition {
    internal let key: String
    internal let notNullable: Bool
    internal let type: String

    public init(key: String, type: String, notNullable: Bool = false) {
        self.key = key
        self.type = type
        self.notNullable = notNullable
    }
}

extension VariableDefinition: UserRepresentable {
    public func userRepresentation() -> String {
        return "$\(key): \(type)\(notNullable ? "!" : "")"
    }
}
