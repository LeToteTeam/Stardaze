//
//  Visitor.swift
//  Stardaze
//
//  Created by William Wilson on 3/7/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

internal protocol Visitor {
    associatedtype T

    func visit(_: Argument) -> T

    func visit(_: Bool) -> T

    func visit(_: Directive) -> T

    func visit(_: Document) -> T

    func visit(_: Double) -> T

    func visit<V>(_: V) -> T where V: RawRepresentable, V.RawValue == String

    func visit(_: Field) -> T

    func visit(_: Fragment) -> T

    func visit(_: [Fragment]) -> T

    func visit(_: Int) -> T

    func visit(_: GraphQLNull) -> T

    func visit(_: QueryOperation) -> T

    func visit(_: [Receiver]) -> T

    func visit(_: String) -> T

    func visit(_: [String: Receiver]) -> T

    func visit(_: Variable) -> T

    func visit(_: VariableDefinition) -> T
}
