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
    internal var fields: [Field]
    internal let name: String
    internal let type: String

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

    public func accept<T>(visitor: Visitor<T>) -> T {
        return visitor.visit(fragment: self)
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
}
