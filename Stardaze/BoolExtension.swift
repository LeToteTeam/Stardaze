//
//  BoolExtension.swift
//  Stardaze
//
//  Created by William Wilson on 3/21/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

extension Bool: Receiver {
    internal func accept<V: Visitor>(visitor: V) -> V.T {
        return visitor.visit(self)
    }
}
