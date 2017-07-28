//
//  Receiver.swift
//  Stardaze
//
//  Created by William Wilson on 3/9/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

internal protocol Receiver {
    func accept(visitor: Visitor) -> String
}
