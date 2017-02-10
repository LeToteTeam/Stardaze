//
//  Directive.swift
//  LTGQL
//
//  Created by William Wilson on 2/9/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public enum Directive {
    case include(Variable)
    case skip(Variable)
}

extension Directive: UserRepresentable {
    func userRepresentation() -> String {
        switch self {
        case .skip(let variable):
            return "@skip(if: $\(variable.key))"
        case .include(let variable):
            return "@include(if: $\(variable.key))"
        }
    }
}
