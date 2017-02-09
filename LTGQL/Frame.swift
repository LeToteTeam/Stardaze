//
//  Frame.swift
//  LTGQL
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public struct Frame {
    var variables: [String: Variable]

    mutating func add(variable: Variable) throws {
        if let _ = variables[variable.key] {
            throw FrameError.variableAlreadyDefined(variableName: variable.key, frame: self)
        }

        variables[variable.key] = variable
    }

    func lookup(variableName: String) throws -> Variable {
        guard let variable = variables[variableName] else {
            throw FrameError.variableUndefined(variableName: variableName, frame: self)
        }

        return variable
    }
}
