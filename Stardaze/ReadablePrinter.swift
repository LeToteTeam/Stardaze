//
//  ReadablePrinter.swift
//  Stardaze
//
//  Created by William Wilson on 3/7/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 The ReadablePrinter is used internally in creating the string that the EncodedPrinter uses. It may also be used for
 debugging issues with the query created by the EncodedPrinter.
 
    let printer = ReadablePrinter()
    let document = Document(...)
    printer.visit(document: document) => {
                                            ...
                                         }
 
    document.accept(visitor: printer) => {
                                            ...
                                         }
 */
public final class ReadablePrinter: Visitor<String> {
    public override init() {}

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
                finishedString.append(",\n")
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
                finishedString.append(",")
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
                finishedString.append(",")
                finishedString.append("\n")
            }

            finishedString.append(fragmentContents(fragment: fragment, depth: depth + 1))
        }

        return finishedString
    }

    private func makeReadableString(valueList: [Value]) -> String {
        var finishedString = "["

        finishedString.append(makeReadableSingleLineString(receiverList: valueList))

        finishedString.append("]")

        return finishedString
    }

    private func makeReadableString(object: [String: Value]) -> String {
        var finishedString = "{"

        for (index, pair) in object.enumerated() {
            if index != 0 {
                finishedString.append(", ")
            }

            finishedString.append(makeReadableString(string: pair.key, value: pair.value))
        }

        finishedString.append("}")

        return finishedString
    }

    private func makeReadableString(string: String, value: Value) -> String {
        return "\(string): \(visit(value))"
    }

    private func makeReadableString(variableDefinitionList: [VariableDefinition]) -> String {
        var finishedString = "("

        finishedString.append(makeReadableSingleLineString(receiverList: variableDefinitionList))

        finishedString.append(")")

        return finishedString
    }

    private func makeReadableVariableValueString(variableDefinition: VariableDefinition) -> String {
        return "\"\(variableDefinition.key)\": \(visit(variableDefinition.value))"
    }

    internal func makeReadableVariableValueListString(variableDefinitionList: [VariableDefinition]) -> String {
        var finishedString = "{"

        for (index, variableDefinition) in zip(0..<variableDefinitionList.count, variableDefinitionList) {
            if index != 0 {
                finishedString.append(", ")
            }
            finishedString.append(makeReadableVariableValueString(variableDefinition: variableDefinition))
        }

        finishedString.append("}")

        return finishedString
    }

    public override func visit(_ argument: Argument) -> String {
        return makeReadableString(string: argument.key, value: argument.value)
    }

    public override func visit(_ directive: Directive) -> String {
        switch directive {
        case .deprecated(let variable):
            return "@deprecated(reason: $\(variable.key))"

        case .include(let variable):
            return "@include(if: $\(variable.key))"

        case .skip(let variable):
            return "@skip(if: $\(variable.key))"
        }
    }

    public override func visit(_ document: Document) -> String {
        var finishedString = visit(document.queryOperation)
        if let fragments = document.fragments, fragments.count > 0 {
            for fragment in fragments {
                finishedString.append("\n\n")
                finishedString.append(visit(fragment))
            }
        }

        if let variableDefinitionList = document.queryOperation.variableDefinitions {
            finishedString.append("\n")

            finishedString.append(makeReadableVariableValueListString(variableDefinitionList: variableDefinitionList))
        }

        return finishedString
    }

    public override func visit(_ field: Field) -> String {
        return makeReadableString(field: field, atDepth: 0)
    }

    public override func visit(_ fragment: Fragment) -> String {
        var finishedString = ""

        finishedString.append("fragment \(fragment.name) on \(fragment.type) {\n")

        finishedString.append(makeReadableString(fieldList: fragment.fields, atDepth: 0))

        finishedString.append("\n}")

        return finishedString
    }

    public override func visit(_ value: Value) -> String {
        switch value {
        case .int(let int):
            return "\(int)"

        case .double(let double):
            return "\(double)"

        case .string(let string):
            return "\"\(string)\""

        case .boolean(let bool):
            return "\(bool)"

        case .null:
            return "null"

        case .enumeration(let string):
            return string

        case .list(let list):
            return makeReadableString(valueList: list)

        case .object(let object):
            return makeReadableString(object: object)

        case .variable(let variable):
            return "$\(variable.key)"
        }
    }

    public override func visit(_ variableDefinition: VariableDefinition) -> String {
        return "$\(variableDefinition.key): \(variableDefinition.type)\(variableDefinition.notNullable ? "!" : "")"
    }

    public override func visit(_ queryOperation: QueryOperation) -> String {
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
