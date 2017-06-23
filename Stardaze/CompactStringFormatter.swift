//
//  CompactStringFormatter.swift
//  Stardaze
//
//  Created by William Wilson on 3/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

internal struct CompactStringFormatter: Visitor {
    let encoded: Bool
    private let unencodedStringFormatter = PrettyPrintedStringFormatter()

    internal init(encoded: Bool) {
        self.encoded = encoded
    }

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
            NSMutableString(string: unencodedStringFormatter.visit(document.queryOperation)
                .replacingOccurrences(of: ",", with: ""))

        if let fragments = document.fragments {
            let transformedFragments =
                NSMutableString(string: unencodedStringFormatter.visit(fragments)
                    .replacingOccurrences(of: ",", with: ""))

            transformedFragments.condenseWhitespace()

            transformedQuery.append(" ")
            transformedQuery.append(String(transformedFragments))
        }

        transformedQuery.condenseWhitespace()

        guard let queryString = transformedQuery.addingPercentEncoding(withAllowedCharacters:
            CharacterSet.urlQueryAllowed) else {
                return ""
        }

        guard let operationName = document.queryOperation.name?.addingPercentEncoding(withAllowedCharacters:
            CharacterSet.urlQueryAllowed) else {
                return "query=\(queryString)"
        }

        let variablesString: String

        if let variableDefinitionList = document.queryOperation.variableDefinitions {
            variablesString =
                unencodedStringFormatter.makeReadableVariableValueListString(variableDefinitionList:
                    variableDefinitionList)
        } else {
            variablesString = ""
        }

        let transformedVariables = NSMutableString(string: variablesString)

        transformedVariables.condenseWhitespace()

        if encoded {
            guard let variablesString =
                transformedVariables.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
                    return "query=\(queryString)&operationName=\(operationName)"
            }

            return "query=\(queryString)&operationName=\(operationName)&variables=\(variablesString)"
        } else {
            return "query=\(transformedQuery)&operationName=\(operationName)&variables=\(transformedVariables)"
        }
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
