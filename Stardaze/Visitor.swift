//
//  Visitor.swift
//  Stardaze
//
//  Created by William Wilson on 3/7/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

internal protocol Visitor {
    func visit(_: Argument) -> String

    func visit(_: Bool) -> String

    func visit(_: Directive) -> String

    func visit(_: Double) -> String

    func visit<EnumType>(_: EnumType) -> String where EnumType: RawRepresentable, EnumType.RawValue == String

    func visit(_: Field) -> String

    func visit(_: Fragment) -> String

    func visit(_: [Fragment]) -> String

    func visit(_: Int) -> String

    func visit(_: GraphQLNull) -> String

    func visit(_: QueryOperation) -> String

    func visit(_: [Receiver]) -> String

    func visit(_: String) -> String

    func visit(_: [String: Receiver]) -> String

    func visit(_: Variable) -> String

    func visit(_: VariableDefinition) -> String
}
