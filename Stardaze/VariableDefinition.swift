//
//  VariableDefinition.swift
//  Stardaze
//
//  Created by William Wilson on 2/9/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 VariableDefinitions are passed onto a query operation so that variables with the same name may be used in fields on
 the query operation.
 */
public struct VariableDefinition {
    internal let key: String
    internal let notNullable: Bool
    internal let type: String
    internal let value: Receiver

    /**
     Initializer for a list variable. When using this, if there is an enum in the list, wrap it in a GraphQLEnum object
     first.
     */
    public init?(key: String, type: String, notNullable: Bool = false, value: [Any]) {
        self.key = key
        self.type = type
        self.notNullable = notNullable
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
     Initializer for a bool variable.
     */
    public init(key: String, type: String, notNullable: Bool = false, value: Bool) {
        self.init(key: key, type: type, notNullable: notNullable, receiver: value)
    }

    /**
     Initializer for a double variable.
     */
    public init(key: String, type: String, notNullable: Bool = false, value: Double) {
        self.init(key: key, type: type, notNullable: notNullable, receiver: value)
    }

    /**
     Initializer for an int variable.
     */
    public init(key: String, type: String, notNullable: Bool = false, value: Int) {
        self.init(key: key, type: type, notNullable: notNullable, receiver: value)
    }

    /**
     Initializer for a null variable.
     */
    public init(key: String, type: String, notNullable: Bool = false, value: GraphQLNull) {
        self.init(key: key, type: type, notNullable: notNullable, receiver: value)
    }

    private init(key: String, type: String, notNullable: Bool, receiver: Receiver) {
        self.key = key
        self.type = type
        self.notNullable = notNullable
        value = receiver
    }

    /**
     Initializer for a string variable.
     */
    public init(key: String, type: String, notNullable: Bool = false, value: String) {
        self.init(key: key, type: type, notNullable: notNullable, receiver: value)
    }

    /**
     Initializer for an object variable. When using this, if there is an enum in the list, wrap it in a
     GraphQLEnum object first.
     */
    public init?(key: String, type: String, notNullable: Bool = false, value: [String: Any]) {
        self.key = key
        self.type = type
        self.notNullable = notNullable
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
     Initializer for an enum variable.
     */
    public init<T>(key: String,
                type: String,
                notNullable: Bool = false,
                value: T) where T: RawRepresentable, T.RawValue == String {
        self.init(key: key, type: type, notNullable: notNullable, receiver: GraphQLEnum(value))
    }
}

extension VariableDefinition: Receiver {
    internal func accept(visitor: Visitor) -> String {
        return visitor.visit(self)
    }
}
