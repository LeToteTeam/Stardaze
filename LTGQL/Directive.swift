//
//  Directive.swift
//  LTGQL
//
//  Created by William Wilson on 2/9/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public enum Directive {
    case deprecated(Variable)
    case include(Variable)
    case skip(Variable)
}

extension Directive: UserRepresentable {
    func userRepresentation() -> String {
        switch self {
        case .deprecated(let variable):
            return "@deprecated(reason: $\(variable.key))"
        case .include(let variable):
            return "@include(if: $\(variable.key))"
        case .skip(let variable):
            return "@skip(if: $\(variable.key))"
        }
    }
}
