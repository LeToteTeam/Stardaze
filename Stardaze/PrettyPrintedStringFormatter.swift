//
//  PrettyPrintedStringFormatter.swift
//  Stardaze
//
//  Created by William Wilson on 3/7/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

internal struct PrettyPrintedStringFormatter: Visitor {
    private func fragmentContents(fragment: Fragment, depth: Int) -> String {
        var finishedString = ""

        space(string: &finishedString, toDepth: depth)

        finishedString.append("...\(fragment.name)")

        return finishedString
    }

    private func makeReadableSingleLineString(receiverList: [Receiver]) -> String {
        var finishedString = ""

        for (index, receiver) in zip(0..<receiverList.count, receiverList) {
            if index != 0 {
                finishedString.append(", ")
            }

            finishedString.append(receiver.accept(visitor: self))
        }

        return finishedString
    }

    private func makeReadableString(argumentList: [Argument]) -> String {
        var finishedString = "("

        finishedString.append(makeReadableSingleLineString(receiverList: argumentList))

        finishedString.append(")")

        return finishedString
    }

    private func makeReadableString(directiveList: [Directive]) -> String {
        var finishedString = " "

        finishedString.append(makeReadableSingleLineString(receiverList: directiveList))

        return finishedString
    }

    private func makeReadableString(field: Field, atDepth depth: Int) -> String {
        var finishedString = ""

        space(string: &finishedString, toDepth: depth)

        if let alias = field.alias {
            finishedString.append("\(alias): ")
        }

        finishedString.append(field.name)

        if let arguments = field.arguments, arguments.count > 0 {
            finishedString.append(makeReadableString(argumentList: arguments))
        }

        if let directives = field.directives {
            finishedString.append(makeReadableString(directiveList: directives))
        }

        if field.subFields != nil || field.fragments != nil {
            finishedString.append(" {\n")

            if let subFields = field.subFields {
                finishedString.append(makeReadableString(fieldList: subFields, atDepth: depth))
            }

            if field.subFields != nil && field.fragments != nil {
                finishedString.append("\n")
            }

            if let fragments = field.fragments {
                finishedString.append(makeReadableString(fragmentList: fragments, atDepth: depth))
            }

            finishedString.append("\n")

            space(string: &finishedString, toDepth: depth)

            finishedString.append("}")
        }

        return finishedString
    }

    private func makeReadableString(fieldList: [Field], atDepth depth: Int) -> String {
        var finishedString = ""

        for (index, field) in zip(0..<fieldList.count, fieldList) {
            if index != 0 {
                finishedString.append("\n")
            }

            finishedString.append(makeReadableString(field: field, atDepth: depth + 1))
        }

        return finishedString
    }

    private func makeReadableString(fragmentList: [Fragment], atDepth depth: Int) -> String {
        var finishedString = ""

        for (index, fragment) in zip(0..<fragmentList.count, fragmentList) {
            if index != 0 {
                finishedString.append("\n")
            }

            finishedString.append(fragmentContents(fragment: fragment, depth: depth + 1))
        }

        return finishedString
    }

    private func makeReadableString(string: String, value: Receiver) -> String {
        return "\(string): \(value.accept(visitor: self))"
    }

    private func makeReadableString(variableDefinitionList: [VariableDefinition]) -> String {
        var finishedString = "("

        finishedString.append(makeReadableSingleLineString(receiverList: variableDefinitionList))

        finishedString.append(")")

        return finishedString
    }

    private func makeReadableVariableValueString(variableDefinition: VariableDefinition) -> String {
        return "\"\(variableDefinition.key)\": \(variableDefinition.value.accept(visitor: self))"
    }

    internal func makeReadableVariableValueListString(variableDefinitionList: [VariableDefinition]) -> String {
        var finishedString = "{\n"

        for (index, variableDefinition) in zip(0..<variableDefinitionList.count, variableDefinitionList) {
            if index != 0 {
                finishedString.append(",\n")
            }
            finishedString.append("\t")
            finishedString.append(makeReadableVariableValueString(variableDefinition: variableDefinition))
        }

        finishedString.append("\n}")

        return finishedString
    }

    internal func visit(_ argument: Argument) -> String {
        return makeReadableString(string: argument.key, value: argument.value)
    }

    internal func visit(_ bool: Bool) -> String {
        return "\(bool)"
    }

    internal func visit(_ directive: Directive) -> String {
        switch directive {
        case .deprecated(let variable):
            return "@deprecated(reason: $\(variable.key))"

        case .include(let variable):
            return "@include(if: $\(variable.key))"

        case .skip(let variable):
            return "@skip(if: $\(variable.key))"
        }
    }

    internal func visit(_ document: Document) -> String {
        var finishedString = visit(document.queryOperation)
        if let fragments = document.fragments, fragments.count > 0 {
            for fragment in fragments {
                finishedString.append("\n\n")
                finishedString.append(visit(fragment))
            }
        }

        if let variableDefinitionList = document.queryOperation.variableDefinitions {
            finishedString.append("\n\n")

            finishedString.append(makeReadableVariableValueListString(variableDefinitionList: variableDefinitionList))
        }

        return finishedString
    }

    internal func visit(_ double: Double) -> String {
        return "\(double)"
    }

    internal func visit<V>(_ enumValue: V) -> String where V: RawRepresentable, V.RawValue == String {
        return enumValue.rawValue
    }

    internal func visit(_ field: Field) -> String {
        return makeReadableString(field: field, atDepth: 0)
    }

    internal func visit(_ fragment: Fragment) -> String {
        var finishedString = ""

        finishedString.append("fragment \(fragment.name) on \(fragment.type) {\n")

        finishedString.append(makeReadableString(fieldList: fragment.fields, atDepth: 0))

        finishedString.append("\n}")

        return finishedString
    }

    internal func visit(_ fragments: [Fragment]) -> String {
        var finishedString = ""

        for fragment in fragments {
            finishedString.append(visit(fragment))
        }

        return finishedString
    }

    internal func visit(_ intValue: Int) -> String {
        return "\(intValue)"
    }

    internal func visit(_ valueList: [Receiver]) -> String {
        var finishedString = "["

        finishedString.append(makeReadableSingleLineString(receiverList: valueList))

        finishedString.append("]")

        return finishedString
    }

    internal func visit(_: GraphQLNull) -> String {
        return "null"
    }

    internal func visit(_ valueObject: [String : Receiver]) -> String {
        var finishedString = "{"

        for (index, pair) in valueObject.enumerated() {
            if index != 0 {
                finishedString.append(", ")
            }

            finishedString.append(makeReadableString(string: pair.key, value: pair.value))
        }

        finishedString.append("}")

        return finishedString
    }

    internal func visit(_ string: String) -> String {
        return "\"\(string)\""
    }

    internal func visit(_ variable: Variable) -> String {
        return "$\(variable.key)"
    }

    internal func visit(_ variableDefinition: VariableDefinition) -> String {
        return "$\(variableDefinition.key): \(variableDefinition.type)\(variableDefinition.notNullable ? "!" : "")"
    }

    internal func visit(_ queryOperation: QueryOperation) -> String {
        var finishedString = ""

        if let name = queryOperation.name {
            finishedString.append(queryOperation.mutating ? "mutation " : "query ")

            finishedString.append(name)

            if let variableDefinitions = queryOperation.variableDefinitions {
                finishedString.append(makeReadableString(variableDefinitionList: variableDefinitions))
            }

            finishedString.append(" ")
        }

        finishedString.append("{\n")

        finishedString.append(makeReadableString(fieldList: queryOperation.fields, atDepth: 0))

        finishedString.append("\n}")

        return finishedString
    }

    private func space(string: inout String, toDepth depth: Int) {
        for _ in 0..<depth {
            string.append("\t")
        }
    }
}
