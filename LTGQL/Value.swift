//
//  Primitive.swift
//  LTGQL
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 Values are used in arguments and variable definitions. At the time being, 64-bit integers
 are being used in this library despite the GraphQL spec specifying 32-bit integers. Please override this if it causes
 issues in your codebase.
 */
public enum Value {
    /**
     A boolean value.
     */
    case boolean(Bool)

    /**
     A double value
     */
    case double(Double)

    /**
     An enumerated value.
     */
    case enumeration(String)

    /**
     A 64-bit integer. The GraphQL spec requires 32-bit integers, so this may cause bugs in dealing with servers where
     the spec is followed strictly. The simplest solution is to override this class and use `Int32` instead.
     */
    case int(Int64)

    /**
     A list of other values.
     */
    indirect case list([Value])

    /**
     The null value
     */
    case null

    /**
     An object mapping strings to other values.
     */
    indirect case object([String: Value])

    /**
     A string.
     */
    case string(String)

    /**
     A variable. When using variables, the variable type definition must be given inside the document.
     */
    case variable(Variable)

    /**
     A stringified version of the value. This is used internally and it may also be used for debugging purposes.
     */
    public static func extractString(value: Value) -> String {
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

    private static func extractList(list: [Value]) -> String {
        var finishedString = "["

        for (index, value) in zip(0..<list.count, list) {
            if index != 0 {
                finishedString.append(", ")
            }
            finishedString.append(extractString(value: value))
        }

        finishedString.append("]")

        return finishedString
    }

    private static func extractObject(object: [String: Value]) -> String {
        var finishedString = "{"

        for (index, pair) in object.enumerated() {
            if index != 0 {
                finishedString.append(", ")
            }

            finishedString.append("\(pair.key): \(extractString(value: pair.value))")
        }

        finishedString.append("}")

        return finishedString
    }
}
