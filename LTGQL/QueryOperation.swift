//
//  QueryOperation.swift
//  LTGQL
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public struct QueryOperation {
    internal var fields: [Field]

    public init(fields: [Field]) {
        self.fields = fields
    }

    public func userRepresentation() -> String {
        var finishedString = "{\n"
        for (index, field) in zip(0..<fields.count, fields) {
            if index != 0 {
                finishedString.append(",")
                finishedString.append("\n")
            }

            finishedString.append(field.userRepresentation(depth: 1))
        }

        finishedString.append("\n}")

        return finishedString
    }
}
