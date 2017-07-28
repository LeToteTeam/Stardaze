//
//  GraphQLList.swift
//  Stardaze
//
//  Created by William Wilson on 3/22/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

internal struct GraphQLList {
    let list: [Receiver]

    internal init(_ list: [Receiver]) {
        self.list = list
    }
}

extension GraphQLList: Receiver {
    internal func accept(visitor: Visitor) -> String {
        return visitor.visit(list)
    }
}
