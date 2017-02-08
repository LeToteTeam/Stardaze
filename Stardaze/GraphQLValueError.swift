//
//  GraphQLValueError.swift
//  Stardaze
//
//  Created by William Wilson on 3/23/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

internal enum GraphQLValueError: String, Error {
    case listConversionError = "One of the items in your list is not a valid GraphQL value."
    case objectConversionError = "One of the items in your object is not a valid GraphQL value."
}
