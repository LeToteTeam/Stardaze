//
//  EncodedStringFormatter.swift
//  Stardaze
//
//  Created by William Wilson on 3/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

internal struct EncodedStringFormatter: Visitor {
    private let unencodedStringFormatter = UnencodedStringFormatter()

    internal func visit(_ argument: Argument) -> String {
        return ""
    }

    internal func visit(_: Bool) -> String {
        return ""
    }

    internal func visit(_ directive: Directive) -> String {
        return ""
    }

    internal func visit(_ document: Document) -> String {
        let transformedQuery =
            NSMutableString(string: unencodedStringFormatter.visit(document).replacingOccurrences(of: ",", with: ""))

        transformedQuery.condenseWhitespace()

        guard let queryString = transformedQuery.addingPercentEncoding(withAllowedCharacters:
            CharacterSet.urlQueryAllowed) else {
                return ""
        }

        guard let operationName = document.queryOperation.name?.addingPercentEncoding(withAllowedCharacters:
            CharacterSet.urlQueryAllowed) else {
                return "query=\(queryString)"
        }

        let variablesMinusCommas: String

        if let variableDefinitionList = document.queryOperation.variableDefinitions {
            variablesMinusCommas =
                unencodedStringFormatter.makeReadableVariableValueListString(variableDefinitionList:
                    variableDefinitionList)
        } else {
            variablesMinusCommas = ""
        }

        let transformedVariables = NSMutableString(string: variablesMinusCommas)

        transformedVariables.condenseWhitespace()

        guard let variablesString =
            transformedVariables.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
                return "query=\(queryString)&operationName=\(operationName)"
        }

        return "query=\(queryString)&operationName=\(operationName)&variables=\(variablesString)"
    }

    internal func visit(_: Double) -> String {
        return ""
    }

    internal func visit(_ field: Field) -> String {
        return ""
    }

    internal func visit(_ fragment: Fragment) -> String {
        return ""
    }

    internal func visit(_ fragments: [Fragment]) -> String {
        return ""
    }

    internal func visit(_: [Receiver]) -> String {
        return ""
    }

    internal func visit(_: String) -> String {
        return ""
    }

    internal func visit(_: GraphQLNull) -> String {
        return ""
    }

    internal func visit(_: Int) -> String {
        return ""
    }

    internal func visit(_: [String : Receiver]) -> String {
        return ""
    }

    internal func visit<V>(_: V) -> String where V: RawRepresentable, V.RawValue == String {
        return ""
    }

    internal func visit(_: Variable) -> String {
        return ""
    }

    internal func visit(_ variableDefinition: VariableDefinition) -> String {
        return ""
    }

    internal func visit(_ queryOperation: QueryOperation) -> String {
        return ""
    }
}
