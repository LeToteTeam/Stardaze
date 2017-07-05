//
//  PrettyPrintedParametersFormatter.swift
//  Stardaze
//
//  Created by William Wilson on 3/15/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

internal struct PrettyPrintedParametersFormatter: Visitor {
    let stringFormatter = OutputFormatter(outputOption: .prettyPrinted, parameterize: false)

    internal func visit(_: Argument) -> [String : Any] {
        return [:]
    }

    internal func visit(_: Bool) -> [String: Any] {
        return [:]
    }

    internal func visit(_: Directive) -> [String : Any] {
        return [:]
    }

    internal func visit(_ document: Document) -> [String : Any] {
        let transformedQuery =
            NSMutableString(string: stringFormatter.visit(document.queryOperation).replacingOccurrences(of: ",",
                                                                                                        with: ""))

        if let fragments = document.fragments {
            let transformedFragments =
                NSMutableString(string: stringFormatter.visit(fragments).replacingOccurrences(of: ",", with: ""))

            transformedQuery.append("\n\n")
            transformedQuery.append(String(transformedFragments))
        }
        var parameters  = ["query": String(transformedQuery)]

        if let name = document.queryOperation.name {
            parameters["operationName"] = name
        }

        if let variablesDefinitionList = document.queryOperation.variableDefinitions {
            let variablesMinusCommas =
                stringFormatter.makeReadableVariableValueListString(variableDefinitionList: variablesDefinitionList)

            let transformedVariables = NSMutableString(string: variablesMinusCommas)

            parameters["variables"] = String(transformedVariables)
        }

        return parameters
    }

    internal func visit(_: Double) -> [String: Any] {
        return [:]
    }

    internal func visit(_: Field) -> [String : Any] {
        return [:]
    }

    internal func visit(_: Fragment) -> [String : Any] {
        return [:]
    }

    internal func visit(_: [Fragment]) -> [String : Any] {
        return [:]
    }

    internal func visit(_: [Receiver]) -> [String: Any] {
        return [:]
    }

    internal func visit(_: GraphQLNull) -> [String: Any] {
        return [:]
    }

    internal func visit(_: Int) -> [String: Any] {
        return [:]
    }

    internal func visit(_: String) -> [String: Any] {
        return [:]
    }

    internal func visit(_: [String : Receiver]) -> [String: Any] {
        return [:]
    }

    internal func visit<V>(_: V) -> [String: Any] where V: RawRepresentable, V.RawValue == String {
        return [:]
    }

    internal func visit(_: Variable) -> [String: Any] {
        return [:]
    }

    internal func visit(_: VariableDefinition) -> [String : Any] {
        return [:]
    }

    internal func visit(_: QueryOperation) -> [String : Any] {
        return [:]
    }
}
