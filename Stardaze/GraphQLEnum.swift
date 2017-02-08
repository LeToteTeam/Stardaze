//
//  GraphQLEnum.swift
//  Stardaze
//
//  Created by William Wilson on 3/21/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 An internal decorator for adding Receiver behavior to Swift enumerations. The only reason to use this is if you
 pass in a list or object containing a Swift enum into an Argument or VariableDefinition.
 */
public struct GraphQLEnum<T> where T: RawRepresentable, T.RawValue == String {
    let enumValue: T

    public init(_ enumValue: T) {
        self.enumValue = enumValue
    }
}

extension GraphQLEnum: Receiver {
    func accept<V: Visitor>(visitor: V) -> V.T {
        return visitor.visit(enumValue)
    }
}
