//
//  DoubleExtension.swift
//  Stardaze
//
//  Created by William Wilson on 3/21/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

extension Double: Receiver {
    internal func accept(visitor: Visitor) -> String {
        return visitor.visit(self)
    }
}
