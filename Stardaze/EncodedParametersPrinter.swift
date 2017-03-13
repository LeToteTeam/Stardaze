//
//  EncodedParametersPrinter.swift
//  Stardaze
//
//  Created by William Wilson on 3/13/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 The EncodedParametersPrinter is used to create a [String: Any] dictionary of parameters, a common format
 used by networking libraries to deal with url parameters
 */
public final class EncodedParametersPrinter: Visitor<[String: Any]> {
    let readablePrinter = ReadablePrinter()
    let whitespaceRegexp = try! NSRegularExpression(pattern: "[ \t\n]+", options: [])

    /**
     Initializes an encoded parameters printer
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
            NSMutableString(string: readablePrinter.visit(document).replacingOccurrences(of: ",", with: ""))

        whitespaceRegexp.replaceMatches(in: transformedQuery,
                                        options: [],
                                        range: transformedQuery.range(of: transformedQuery as String),
                                        withTemplate: " ")

        guard let queryString = transformedQuery.addingPercentEncoding(withAllowedCharacters:
            CharacterSet.urlQueryAllowed) else {
            return [:]
        }

        var parameters = ["query": queryString]

        guard let operationName = document.queryOperation.name?.addingPercentEncoding(withAllowedCharacters:
            CharacterSet.urlQueryAllowed) else {
                return parameters
        }

        parameters["operationName"] = operationName

        let variablesMinusComas: String

        if let variableDefinitionList = document.queryOperation.variableDefinitions {
            variablesMinusComas = readablePrinter.makeReadableVariableValueListString(variableDefinitionList:
                variableDefinitionList)
        } else {
            variablesMinusComas = ""
        }

        let transformedVariables = NSMutableString(string: variablesMinusComas)

        whitespaceRegexp.replaceMatches(in: transformedVariables,
                                        options: [],
                                        range: transformedVariables.range(of: transformedVariables as String),
                                        withTemplate: " ")

        guard let variablesString = transformedVariables.addingPercentEncoding(withAllowedCharacters:
            CharacterSet.urlQueryAllowed) else {
                return parameters
        }

        parameters["variables"] = variablesString

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
