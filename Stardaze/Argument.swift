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
    internal var value: Receiver

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
        self.value = ""
        let renamedValue = value

        do {
            let converted = try renamedValue.map({ (element) throws -> Receiver in
                if let gqlValue = element as? Receiver {
                    return gqlValue
                } else if let list = element as? [Any], let gqlList = try? createGraphQLList(list) {
                    return gqlList
                } else if let object = element as? [String: Any],
                    let gqlObject = try? createGraphQLObject(object) {
                    return gqlObject
                } else {
                    throw GraphQLValueError.objectConversionError
                }
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
        self.value = ""
        var renamedValue = value
        do {
            var receiverDict = [String: Receiver]()
            for (key, anyValue) in renamedValue {
                if let gqlValue = anyValue as? Receiver {
                    receiverDict[key] = gqlValue
                } else if let list = anyValue as? [Any],
                    let gqlList = try? createGraphQLList(list) {
                    receiverDict[key] = gqlList
                } else if let object = anyValue as? [String: Any],
                    let gqlObject = try? createGraphQLObject(object) {
                    receiverDict[key] = gqlObject
                } else {
                    throw GraphQLValueError.objectConversionError
                }
            }

            self.value = GraphQLObject(receiverDict)
        } catch (let e) {
            NSLog(e.localizedDescription)
            return nil
        }
    }
    
    func createGraphQLObject(_ dict: [String: Any]) throws -> GraphQLObject {
        do {
            let receiverList: [(String, Receiver)] = try dict.map { (key, value) in
                if let receiver = value as? Receiver {
                    return (key, receiver)
                } else if let subList = value as? [Any] {
                    do {
                        return try (key, createGraphQLList(subList))
                    } catch (let e) {
                        throw e
                    }
                } else if let dict = value as? [String: Any] {
                    do {
                        return try (key, createGraphQLObject(dict))
                } catch (let e) {
                    throw e
                    }
                } else {
                    throw GraphQLValueError.objectConversionError
                }
            }
            
            let receiverDict = Dictionary(receiverList, uniquingKeysWith: { (first, _) in
                return first
            })
        
            return GraphQLObject(receiverDict)
        } catch (let e) {
            throw e
        }
    }
    
    func createGraphQLList(_ list: [Any]) throws -> GraphQLList {
        do {
            let receiverList: [Receiver] = try list.map { (object) in
                if let receiver = object as? Receiver {
                    return receiver
                } else if let subList = object as? [Any] {
                    do {
                        return try createGraphQLList(subList)
                    } catch (let e) {
                        throw e
                    }
                } else if let dict = object as? [String: Any] {
                    do {
                        return try createGraphQLObject(dict)
                    } catch (let e) {
                        throw e
                    }
                } else {
                    throw GraphQLValueError.listConversionError
                }
            }
            
            return GraphQLList(receiverList)
        } catch (let e) {
            throw e
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
    internal func accept(visitor: Visitor) -> String {
        return visitor.visit(self)
    }
}
