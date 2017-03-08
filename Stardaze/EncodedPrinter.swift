//
//  EncodedPrinter.swift
//  Stardaze
//
//  Created by William Wilson on 3/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public final class EncodedPrinter: Visitor<String> {
    let readablePrinter = ReadablePrinter()
    let whitespaceRegexp = try! NSRegularExpression(pattern: "[ \t\n]+", options: [])
    public override init() {}

    internal override func visit(argument: Argument) -> String {
        return ""
    }

    internal override func visit(directive: Directive) -> String {
        return ""
    }

    public override func visit(document: Document) -> String {
        let transformedQuery =
            NSMutableString(string: readablePrinter.visit(document: document).replacingOccurrences(of: ",", with: ""))

        whitespaceRegexp.replaceMatches(in: transformedQuery,
                                        options: [],
                                        range: transformedQuery.range(of: transformedQuery as String),
                                        withTemplate: " ")

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
                readablePrinter.makeReadableVariableValueListString(variableDefinitionList: variableDefinitionList)
        } else {
            variablesMinusCommas = ""
        }

        let transformedVariables = NSMutableString(string: variablesMinusCommas)

        whitespaceRegexp.replaceMatches(in: transformedVariables,
                              options: [],
                              range: transformedVariables.range(of: transformedVariables as String),
                              withTemplate: " ")

        guard let variablesString =
            transformedVariables.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
                return "query=\(queryString)"
        }

        return "query=\(queryString)&operationName=\(operationName)&variables=\(variablesString)"
    }

    internal override func visit(field: Field) -> String {
        return ""
    }

    internal override func visit(fragment: Fragment) -> String {
        return ""
    }

    internal override func visit(queryOperation: QueryOperation) -> String {
        return ""
    }

    internal override func visit(value: Value) -> String {
        return ""
    }

    internal override func visit(variableDefinition: VariableDefinition) -> String {
        return ""
    }
}
