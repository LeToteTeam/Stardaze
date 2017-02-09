//
//  Primitive.swift
//  LTGQL
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

enum Value {
    case int(value: Int64)
    case double(value: Double)
    case string(value: String)
    case boolean(value: Bool)
    case null
    case enumeration(value: String)
    indirect case list(value: [Value])
    indirect case object(value: [String: Value])
    case variableLookup(value: String)
}
