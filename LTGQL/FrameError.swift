//
//  FrameError.swift
//  LTGQL
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

enum FrameError: Error {
    case variableAlreadyDefined(variableName: String, frame: Frame)
    case variableUndefined(variableName: String, frame: Frame)
}

extension FrameError: CustomStringConvertible {
    var description: String {
        switch self {
        case .variableAlreadyDefined(let variableName, let frame):
            return "Duplicate definition of \(variableName) in \(frame)."
        case .variableUndefined(let variableName, let frame):
            return "\(variableName) is undefined in \(frame)"
        }
    }
}
