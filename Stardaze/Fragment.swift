//
//  Fragment.swift
//  Stardaze
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 Fragments are used to specify subfields in such a way that they may be used in one or more areas. Any fragment that
 is used should be passed both to the document and to the field or subfield in which is should appear.
 */
public struct Fragment {
    private var fields: [Field]
    private let name: String
    private let type: String

    /**
     The primary initializer
     
     - parameter name: The name of the fragment.
     
     - parameter type: The type of object that the fragment may be used on.
     
     - prameter fields: The fields that will appear in the response when the fragment is passed into a field.
     */
    public init(name: String, type: String, fields: [Field]) {
        self.name = name
        self.type = type
        self.fields = fields
    }

    /**
     Appends a single field to the fragment.
     
     - parameter field: The field to appear on the fragment.
     */
    public mutating func append(field: Field) {
        fields.append(field)
    }

    /**
     Appends multiple fields to the fragment.
     
     - parameter fields: The fields to appear on the fragment.
     */
    public mutating func append(fields: [Field]) {
        self.fields.append(contentsOf: fields)
    }

    /**
     A stringified version of the field. This is used internally and it may also be used for debugging.
     */
    public func userRepresentation(depth: Int) -> String {
        var finishedString = ""

        for _ in 0..<depth {
            finishedString.append("\t")
        }

        finishedString.append("...\(name)")

        return finishedString
    }

    /**
     A stringified version of the definition of the field. This is used internally and it may also be used for
     debugging.
     */
    public func userDefinitionRepresentation() -> String {
        var finishedString = ""

        finishedString.append("fragment \(name) on \(type) {\n")

        for field in fields {
            finishedString.append(field.userRepresentation(depth: 1))
            finishedString.append("\n")
        }

        finishedString.append("}")

        return finishedString
    }
}
