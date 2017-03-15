//
//  Visitor.swift
//  Stardaze
//
//  Created by William Wilson on 3/7/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 An abstract base class for string formatters and other objects that need to visit all the nodes in a hierarchy.
 */
public class Visitor<T> {
    internal init() {}
    private let virtualFunctionError = "Virtual function must be overridden"
    internal func visit(_: Argument) -> T {
        fatalError(virtualFunctionError)
    }

    internal func visit(_: Directive) -> T {
        fatalError(virtualFunctionError)
    }

    internal func visit(_: Document) -> T {
        fatalError(virtualFunctionError)
    }

    internal func visit(_: Field) -> T {
        fatalError(virtualFunctionError)
    }

    internal func visit(_: Fragment) -> T {
        fatalError(virtualFunctionError)
    }
    
    internal func visit(_: [Fragment]) -> T {
        fatalError(virtualFunctionError)
    }

    internal func visit(_: QueryOperation) -> T {
        fatalError(virtualFunctionError)
    }

    internal func visit(_: Value) -> T {
        fatalError(virtualFunctionError)
    }

    internal func visit(_: VariableDefinition) -> T {
        fatalError(virtualFunctionError)
    }
}
