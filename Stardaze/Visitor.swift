//
//  Visitor.swift
//  Stardaze
//
//  Created by William Wilson on 3/7/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 An abstract base class for adding in printers and other objects that need to visit all the nodes in a hierarchy.
 */
public class Visitor<T> {
    internal init() {}
    private let virtualFunctionError = "Virtual function must be overridden"
    internal func visit(argument: Argument) -> T {
        fatalError(virtualFunctionError)
    }

    internal func visit(directive: Directive) -> T {
        fatalError(virtualFunctionError)
    }

    internal func visit(document: Document) -> T {
        fatalError(virtualFunctionError)
    }

    internal func visit(field: Field) -> T {
        fatalError(virtualFunctionError)
    }

    internal func visit(fragment: Fragment) -> T {
        fatalError(virtualFunctionError)
    }

    internal func visit(queryOperation: QueryOperation) -> T {
        fatalError(virtualFunctionError)
    }

    internal func visit(value: Value) -> T {
        fatalError(virtualFunctionError)
    }

    internal func visit(variableDefinition: VariableDefinition) -> T {
        fatalError(virtualFunctionError)
    }
}
