//
//  Argument.swift
//  Stardaze
//
//  Created by William Wilson on 2/8/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 Arguments are used to pass in additional information in fields, typically related to filtering or sorting.
 */
public struct Argument {
    internal let key: String
    internal let value: Receiver

    private init(key: String, receiver: Receiver) {
        self.key = key
        value = receiver
    }

    /**
     Initializer for an argument that accepts a list. When using this, if the list includes an enum, wrap the enum
     in a GraphQLEnum object first.
     */
    public init?(key: String, value: [Any]) {
        self.key = key

        do {
            let converted = try value.map({ (element) throws -> Receiver in
                guard let gqlValue = element as? Receiver else {
                    throw GraphQLValueError.objectConversionError
                }
                return gqlValue
            })

            self.value = GraphQLList(converted)
        } catch (let e) {
            NSLog(e.localizedDescription)
            return nil
        }
    }

    /**
     Initializer for an argument that accepts a boolean.
     */
    public init(key: String, value: Bool) {
        self.init(key: key, receiver: value)
    }

    /**
     Initializer for an argument that accepts a double.
     */
    public init(key: String, value: Double) {
        self.init(key: key, receiver: value)
    }

    /**
     Initializer for an argument that accepts an integer.
     */
    public init(key: String, value: Int) {
        self.init(key: key, receiver: value)
    }

    /**
     Initializer for an argument that accepts nil.
     */
    public init(key: String, value: GraphQLNull) {
        self.init(key: key, receiver: value)
    }

    /**
     Initializer for an argument that accepts a string.
     */
    public init(key: String, value: String) {
        self.init(key: key, receiver: value)
    }

    /**
     Initializer for an argument that accepts an object. When using this, if the object includes an enum, wrap the enum
     in a GraphQLEnum object first.
     */
    public init?(key: String, value: [String: Any]) {
        self.key = key
        do {
            var receiverDict = [String: Receiver]()
            for (key, anyValue) in value {
                guard let gqlValue = anyValue as? Receiver else {
                    throw GraphQLValueError.listConversionError
                }
                receiverDict[key] = gqlValue
            }

            self.value = GraphQLObject(receiverDict)
        } catch (let e) {
            NSLog(e.localizedDescription)
            return nil
        }
    }

    /**
     Initializer for an argument that accepts an enum.
     */
    public init<T>(key: String, value: T) where T: RawRepresentable, T.RawValue == String {
        self.init(key: key, receiver: GraphQLEnum(value))
    }

    /**
     Initizlizer for an argument that accepts a variable.
     */
    public init(key: String, value: Variable) {
        self.init(key: key, receiver: value)
    }
}

extension Argument: Receiver {
    internal func accept<V: Visitor>(visitor: V) -> V.T {
        return visitor.visit(self)
    }
}
