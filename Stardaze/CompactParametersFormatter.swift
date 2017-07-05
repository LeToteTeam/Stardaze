//
//  CompactParametersFormatter.swift
//  Stardaze
//
//  Created by William Wilson on 3/13/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

internal struct CompactParametersFormatter: Visitor {
    let encoded: Bool
    let stringFormatter = OutputFormatter(outputOption: .prettyPrinted, parameterize: false)

    init(encoded: Bool) {
        self.encoded = encoded
    }

    internal func visit(_: Argument) -> [String: Any] {
        return [:]
    }

    internal func visit(_: Bool) -> [String: Any] {
        return [:]
    }

    internal func visit(_: Directive) -> [String: Any] {
        return [:]
    }

    internal func visit(_ document: Document) -> [String: Any] {
        let transformedQuery =
            NSMutableString(string: stringFormatter.visit(document.queryOperation).replacingOccurrences(of: ",",
                                                                                                        with: ""))

        transformedQuery.condenseWhitespace()

        if let fragments = document.fragments {
            let transformedFragments =
                NSMutableString(string: stringFormatter.visit(fragments).replacingOccurrences(of: ",", with: ""))
            transformedFragments.condenseWhitespace()

            transformedQuery.append(" ")
            transformedQuery.append(String(transformedFragments))
        }

        var parameters: [String: String]
        if encoded {
            guard let queryString = transformedQuery.addingPercentEncoding(withAllowedCharacters:
                CharacterSet.urlQueryAllowed) else {
                    return [:]
            }

            parameters = ["query": queryString]
        } else {
            parameters = ["query": transformedQuery as String]
        }

        if encoded {
            if let operationName = document.queryOperation.name?.addingPercentEncoding(withAllowedCharacters:
                CharacterSet.urlQueryAllowed) {
                parameters["operationName"] = operationName
            }
        } else {
            if let operationName = document.queryOperation.name {
                parameters["operationName"] = operationName
            }
        }

        if let variableDefinitionList = document.queryOperation.variableDefinitions {
            let variablesStripped =
                NSMutableString(string: stringFormatter.makeReadableVariableValueListString(variableDefinitionList:
                    variableDefinitionList))

            variablesStripped.condenseWhitespace()

            if encoded {
                if let variablesString = variablesStripped.addingPercentEncoding(withAllowedCharacters:
                    CharacterSet.urlQueryAllowed) {
                    parameters["variables"] = variablesString as String
                }
            } else {
                parameters["variables"] = variablesStripped as String
            }
        }

        return parameters
    }

    internal func visit(_: Double) -> [String: Any] {
        return [:]
    }

    internal func visit(_ field: Field) -> [String: Any] {
        return [:]
    }

    internal func visit(_ fragment: Fragment) -> [String: Any] {
        return [:]
    }

    internal func visit(_: [Fragment]) -> [String: Any] {
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

    internal func visit(_ variableDefinition: VariableDefinition) -> [String: Any] {
        return [:]
    }

    internal func visit(_ queryOperation: QueryOperation) -> [String: Any] {
        return [:]
    }
}
