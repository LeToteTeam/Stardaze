//
//  GraphQLObject.swift
//  Stardaze
//
//  Created by William Wilson on 3/22/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

internal struct GraphQLObject {
    let object: [String: Receiver]

    internal init(_ object: [String: Receiver]) {
        self.object = object
    }
}

extension GraphQLObject: Receiver {
    internal func accept(visitor: Visitor) -> String {
        return visitor.visit(object)
    }
}
