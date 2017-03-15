//
//  UnencodedParametersFormatter.swift
//  Stardaze
//
//  Created by William Wilson on 3/15/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 The UnencodedParametersFormatter is used to create a [String: Any]
 dictionary of parameters.
 */
public final class UnencodedParametersFormatter: Visitor<[String: Any]> {
    let stringFormatter = UnencodedStringFormatter()
    let whitespaceRegexp = try! NSRegularExpression(pattern: "[ \t\n]+", options: [])
    
    /**
     Initializes an unencoded parameters formatter
     */
    public override init() {}
    
    internal override func visit(_: Argument) -> [String : Any] {
        return [:]
    }
    
    internal override func visit(_: Value) -> [String : Any] {
        return [:]
    }
    
    internal override func visit(_: Directive) -> [String : Any] {
        return [:]
    }
    
    /**
     Creates an unencoded parameters dictionary for a Document with keys query, operationName, and variables
     */
    public override func visit(_ document: Document) -> [String : Any] {
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
        var parameters  = ["query": String(transformedQuery)]
        
        if let name = document.queryOperation.name {
            parameters["operationName"] = name
        }
        
        if let variablesDefinitionList = document.queryOperation.variableDefinitions {
            let variablesMinusCommas =
                stringFormatter.makeReadableVariableValueListString(variableDefinitionList: variablesDefinitionList)
            
            let transformedVariables = NSMutableString(string: variablesMinusCommas)
            transformedVariables.condenseWhitespace()
            
            parameters["variables"] = String(transformedVariables)
        }
        
        return parameters
    }
    
    internal override func visit(_: Field) -> [String : Any] {
        return [:]
    }
    
    internal override func visit(_: Fragment) -> [String : Any] {
        return [:]
    }
    
    internal override func visit(_: [Fragment]) -> [String : Any] {
        return [:]
    }
    
    internal override func visit(_: QueryOperation) -> [String : Any] {
        return [:]
    }
    
    internal override func visit(_: VariableDefinition) -> [String : Any] {
        return [:]
    }
}
