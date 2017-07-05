//
//  StringExtension.swift
//  Stardaze
//
//  Created by William Wilson on 3/22/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

extension String: Receiver {
    internal func accept(visitor: Visitor) -> String {
        return visitor.visit(self)
    }
}
