//
//  EncodedParametersFormatter.swift
//  Stardaze
//
//  Created by William Wilson on 3/13/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 The EncodedParametersFormatter is used to create a [String: Any] 
 dictionary of parameters with percent encoded strings as the values.
 */
public final class EncodedParametersFormatter: Visitor<[String: Any]> {
    let stringFormatter = UnencodedStringFormatter()
    let whitespaceRegexp = try! NSRegularExpression(pattern: "[ \t\n]+", options: [])

    /**
     Initializes an encoded parameters formatter
     */
    public override init() {}

    internal override func visit(_: Argument) -> [String: Any] {
        return [:]
    }

    internal override func visit(_: Directive) -> [String: Any] {
        return [:]
    }

    /**
     Creates an encoded parameters dictionary for a Document with keys query, operationName, and variables
     */
    public override func visit(_ document: Document) -> [String: Any] {
        let transformedQuery =
            NSMutableString(string: stringFormatter.visit(document.queryOperation).replacingOccurrences(of: ",", with: ""))

        transformedQuery.condenseWhitespace()

        if let fragments = document.fragments {
            let transformedFragments =
                NSMutableString(string: stringFormatter.visit(fragments).replacingOccurrences(of: ",", with: ""))
            transformedFragments.condenseWhitespace()
            
            transformedQuery.append(" ")
            transformedQuery.append(String(transformedFragments))
        }
        
        guard let queryString = transformedQuery.addingPercentEncoding(withAllowedCharacters:
            CharacterSet.urlQueryAllowed) else {
            return [:]
        }
        var parameters = ["query": queryString]

        if let operationName = document.queryOperation.name?.addingPercentEncoding(withAllowedCharacters:
            CharacterSet.urlQueryAllowed) {
            parameters["operationName"] = operationName
        }


        if let variableDefinitionList = document.queryOperation.variableDefinitions {
            let variablesMinusCommas = NSMutableString(string: stringFormatter.makeReadableVariableValueListString(variableDefinitionList:
                variableDefinitionList))

            variablesMinusCommas.condenseWhitespace()

            if let variablesString = variablesMinusCommas.addingPercentEncoding(withAllowedCharacters:
                CharacterSet.urlQueryAllowed) {
                parameters["variables"] = variablesString
            }
        }
        
        return parameters
    }

    internal override func visit(_ field: Field) -> [String: Any] {
        return [:]
    }

    internal override func visit(_ fragment: Fragment) -> [String: Any] {
        return [:]
    }

    internal override func visit(_ queryOperation: QueryOperation) -> [String: Any] {
        return [:]
    }

    internal override func visit(_ value: Value) -> [String: Any] {
        return [:]
    }

    internal override func visit(_ variableDefinition: VariableDefinition) -> [String: Any] {
        return [:]
    }
}
