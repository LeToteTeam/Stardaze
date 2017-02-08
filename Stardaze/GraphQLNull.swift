//
//  GraphQLValueNull.swift
//  Stardaze
//
//  Created by William Wilson on 3/21/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 An intertal structure for dealing with nil literals in Arguments and VariableDefinitions.
 */
public struct GraphQLNull {
    public init(nilLiteral: ()) {}
}

extension GraphQLNull: ExpressibleByNilLiteral {}

extension GraphQLNull: Receiver {
    internal func accept<V: Visitor>(visitor: V) -> V.T {
        return visitor.visit(self)
    }
}
