//
//  ArrayExtension.swift
//  LTGQL
//
//  Created by William Wilson on 2/9/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

extension Array where Element:UserRepresentable {
    func userRepresentation() -> String {
        var string = ""
        for (index, element) in zip(0..<self.count, self) {
            if index != 0 {
                string.append(", ")
            }
            
            string.append(element.userRepresentation())
        }
        
        return string
    }
}
