//
//  Query.swift
//  LTGQL
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

public struct Query {
    internal var fields: [Field]
    internal var fragments: [Fragment]?

    public init(fields: [Field], fragments: [Fragment]? = nil) {
        self.fields = fields
        self.fragments = fragments
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

        if let fragments = fragments {
            for fragment in fragments {
                finishedString.append("\n\n")
                finishedString.append(fragment.userDefinitionRepresentation())
            }
        }
        return finishedString
    }
}
