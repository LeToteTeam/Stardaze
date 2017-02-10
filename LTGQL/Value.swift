//
//  Primitive.swift
//  LTGQL
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public enum Value {
    case boolean(Bool)
    case double(Double)
    case enumeration(String)
    case int(Int32)
    indirect case list([Value])
    case null
    indirect case object([String: Value])
    case string(String)
    case variable(Variable)

    static func extractString(value: Value) -> String {
        switch value {
        case int(let int):
            return "\(int)"
        case double(let double):
            return "\(double)"
        case string(let string):
            return "\"\(string)\""
        case boolean(let bool):
            return "\(bool)"
        case null:
            return "null"
        case enumeration(let string):
            return string
        case list(let list):
            return extractList(list: list)
        case object(let object):
            return extractObject(object: object)
        case variable(let variable):
            return "$\(variable.key)"
        }
    }

    static func extractList(list: [Value]) -> String {
        var finishedString = "["

        for (index, value) in zip(0..<list.count, list) {
            if index != 0 {
                finishedString.append(",")
            }
            finishedString.append(extractString(value: value))
        }

        finishedString.append("]")

        return finishedString
    }

    static func extractObject(object: [String: Value]) -> String {
        var finishedString = "{"

        for (index, pair) in object.enumerated() {
            if index != 0 {
                finishedString.append(",")
            }

            finishedString.append("\(pair.key): \(extractString(value: pair.value))")
        }

        finishedString.append("}")

        return finishedString
    }
}
