//
//  EncodedStringFormatter.swift
//  Stardaze
//
//  Created by William Wilson on 3/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 The EncodedStringFormatter is used to create a percent encoded query string.
 */
public final class EncodedStringFormatter: Visitor<String> {
    let unencodedStringFormatter = UnencodedStringFormatter()
    let whitespaceRegexp = try! NSRegularExpression(pattern: "[ \t\n]+", options: [])

    /**
     Initializes an encoded string formatter.
     */
    public override init() {}

    internal override func visit(_ argument: Argument) -> String {
        return ""
    }

    internal override func visit(_ directive: Directive) -> String {
        return ""
    }

    /**
     Creates an encoded String for a Document
     
     ``` swift
     var unnamedDocument = Document(queryOperation: QueryOperation(fields: [Field(name: "products")]))
     unnamedDocument.append(fragment: Fragment(name: "idFragment", type: "Product", fields: [Field(name: "id")]))
     
     visit(unnamedDocument) => "query=%7B%20products%20%7D%20fragment%20idFragment%20on%20Product%20%7B%20id%20%7D"
     ```
     */
    public override func visit(_ document: Document) -> String {
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

    internal override func visit(_ field: Field) -> String {
        return ""
    }

    internal override func visit(_ fragment: Fragment) -> String {
        return ""
    }
    
    internal override func visit(_ fragments: [Fragment]) -> String {
        return ""
    }

    internal override func visit(_ queryOperation: QueryOperation) -> String {
        return ""
    }

    internal override func visit(_ value: Value) -> String {
        return ""
    }

    internal override func visit(_ variableDefinition: VariableDefinition) -> String {
        return ""
    }
}
