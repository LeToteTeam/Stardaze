//
//  Directive.swift
//  Stardaze
//
//  Created by William Wilson on 2/9/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 Directives are used to indicate special information about a field based on variables passed along with the document.
 They may be used to skip or include a field. They may also be used to indicate deprecation of the field.
 */
public enum Directive {
    /**
     A directive used to indicate deprecation. The variable is the reason that the field has been deprecated.
     */
    case deprecated(Variable)

    /**
     A directive used to include a variable based on a specific condition. The variable is the test condition for
     including the field.
     */
    case include(Variable)

    /**
     A directive used to skip a variable based on a specific condition. The variable is the test condition for skipping
     the field.
     */
    case skip(Variable)
}

extension Directive: Receiver {
    internal func accept(visitor: Visitor) -> String {
        return visitor.visit(self)
    }
}
