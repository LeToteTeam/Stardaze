//
//  UnencodedStringFormatter.swift
//  Stardaze
//
//  Created by William Wilson on 3/7/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 The UnencodedStringFormatter is used internally. It may also be used for
 debugging issues with the query.
 
    let stringFormatter = UnencodedStringFormatter()
    let document = Document(...)
    stringFormatter.visit(document: document) => {
                                                    ...
                                                 }
 
    document.accept(visitor: stringFormatter) => {
                                                    ...
                                                 }
 */
public final class UnencodedStringFormatter: Visitor<String> {
    /**
     Initializes an unencoded string formatter.
     */
    public override init() {}

    private func fragmentContents(fragment: Fragment, depth: Int) -> String {
        var finishedString = ""

        space(string: &finishedString, toDepth: depth)

        finishedString.append("...\(fragment.name)")

        return finishedString
    }

    private func makeReadableSingleLineString(receiverList: [Receiver]) -> String {
        var finishedString = ""

        for (index, receiver) in zip(0..<receiverList.count, receiverList) {
            if index != 0 {
                finishedString.append(", ")
            }

            finishedString.append(receiver.accept(visitor: self))
        }

        return finishedString
    }

    private func makeReadableString(argumentList: [Argument]) -> String {
        var finishedString = "("

        finishedString.append(makeReadableSingleLineString(receiverList: argumentList))

        finishedString.append(")")

        return finishedString
    }

    private func makeReadableString(directiveList: [Directive]) -> String {
        var finishedString = " "

        finishedString.append(makeReadableSingleLineString(receiverList: directiveList))

        return finishedString
    }

    private func makeReadableString(field: Field, atDepth depth: Int) -> String {
        var finishedString = ""

        space(string: &finishedString, toDepth: depth)

        if let alias = field.alias {
            finishedString.append("\(alias): ")
        }

        finishedString.append(field.name)

        if let arguments = field.arguments, arguments.count > 0 {
            finishedString.append(makeReadableString(argumentList: arguments))
        }

        if let directives = field.directives {
            finishedString.append(makeReadableString(directiveList: directives))
        }

        if field.subFields != nil || field.fragments != nil {
            finishedString.append(" {\n")

            if let subFields = field.subFields {
                finishedString.append(makeReadableString(fieldList: subFields, atDepth: depth))
            }

            if field.subFields != nil && field.fragments != nil {
                finishedString.append(",\n")
            }

            if let fragments = field.fragments {
                finishedString.append(makeReadableString(fragmentList: fragments, atDepth: depth))
            }

            finishedString.append("\n")

            space(string: &finishedString, toDepth: depth)

            finishedString.append("}")
        }

        return finishedString
    }

    private func makeReadableString(fieldList: [Field], atDepth depth: Int) -> String {
        var finishedString = ""

        for (index, field) in zip(0..<fieldList.count, fieldList) {
            if index != 0 {
                finishedString.append(",")
                finishedString.append("\n")
            }

            finishedString.append(makeReadableString(field: field, atDepth: depth + 1))
        }

        return finishedString
    }

    private func makeReadableString(fragmentList: [Fragment], atDepth depth: Int) -> String {
        var finishedString = ""

        for (index, fragment) in zip(0..<fragmentList.count, fragmentList) {
            if index != 0 {
                finishedString.append(",")
                finishedString.append("\n")
            }

            finishedString.append(fragmentContents(fragment: fragment, depth: depth + 1))
        }

        return finishedString
    }

    private func makeReadableString(valueList: [Value]) -> String {
        var finishedString = "["

        finishedString.append(makeReadableSingleLineString(receiverList: valueList))

        finishedString.append("]")

        return finishedString
    }

    private func makeReadableString(object: [String: Value]) -> String {
        var finishedString = "{"

        for (index, pair) in object.enumerated() {
            if index != 0 {
                finishedString.append(", ")
            }

            finishedString.append(makeReadableString(string: pair.key, value: pair.value))
        }

        finishedString.append("}")

        return finishedString
    }

    private func makeReadableString(string: String, value: Value) -> String {
        return "\(string): \(visit(value))"
    }

    private func makeReadableString(variableDefinitionList: [VariableDefinition]) -> String {
        var finishedString = "("

        finishedString.append(makeReadableSingleLineString(receiverList: variableDefinitionList))

        finishedString.append(")")

        return finishedString
    }

    private func makeReadableVariableValueString(variableDefinition: VariableDefinition) -> String {
        return "\"\(variableDefinition.key)\": \(visit(variableDefinition.value))"
    }

    internal func makeReadableVariableValueListString(variableDefinitionList: [VariableDefinition]) -> String {
        var finishedString = "{"

        for (index, variableDefinition) in zip(0..<variableDefinitionList.count, variableDefinitionList) {
            if index != 0 {
                finishedString.append(", ")
            }
            finishedString.append(makeReadableVariableValueString(variableDefinition: variableDefinition))
        }

        finishedString.append("}")

        return finishedString
    }

    /**
     Creates a String for Arguments

     ``` swift
     visit(Argument(key: "id", value: .int(5))) => "id: 5"
     ```
     */
    public override func visit(_ argument: Argument) -> String {
        return makeReadableString(string: argument.key, value: argument.value)
    }

    /**
     Creates a String for Directives

     ``` swift
     visit(Directive.include(Variable("includeIf"))) => "@include(if: $includeIf)"
     ```
     */
    public override func visit(_ directive: Directive) -> String {
        switch directive {
        case .deprecated(let variable):
            return "@deprecated(reason: $\(variable.key))"

        case .include(let variable):
            return "@include(if: $\(variable.key))"

        case .skip(let variable):
            return "@skip(if: $\(variable.key))"
        }
    }

    /**
     Creates a String for Documents

     ``` swift
     visit(Document(queryOperation: 
         QueryOperation(name: "Product", 
                        variableDefinitions: [VariableDefinition(key: "id", 
                                                                 type: "Int", 
                                                                 notNullable: true, 
                                                                 value: .int(5))],
                        fields: [Field(name: product, arguments: Argument(key: "id", value: .variable("id")))]))) =>
     
     "query Product($id: Int) {
         product(id: $id) {
             id
         }
     }
     {"id": 5}"
     ```
     */
    public override func visit(_ document: Document) -> String {
        var finishedString = visit(document.queryOperation)
        if let fragments = document.fragments, fragments.count > 0 {
            for fragment in fragments {
                finishedString.append("\n\n")
                finishedString.append(visit(fragment))
            }
        }

        if let variableDefinitionList = document.queryOperation.variableDefinitions {
            finishedString.append("\n")

            finishedString.append(makeReadableVariableValueListString(variableDefinitionList: variableDefinitionList))
        }

        return finishedString
    }

    /**
     Creates a String for Fields

     ``` swift
     visit(Field(name: "test_field", alias: "testField", subFields: [Field(name: "id")])) =>

     "testField: test_field {
         id
     }" 
     ```
     */
    public override func visit(_ field: Field) -> String {
        return makeReadableString(field: field, atDepth: 0)
    }

    /**
     Creates a String for Fragments

     ``` swift
     visit(Fragment(name: "testFragment", type: "TestObject", fields: [Field(name: "id")])) =>

     "fragment testFragment on TestObject {
          id
     }"
     ```
     */
    public override func visit(_ fragment: Fragment) -> String {
        var finishedString = ""

        finishedString.append("fragment \(fragment.name) on \(fragment.type) {\n")

        finishedString.append(makeReadableString(fieldList: fragment.fields, atDepth: 0))

        finishedString.append("\n}")

        return finishedString
    }
    
    /**
     Creates a String for Fragments
     
     ``` swift
     visit(Fragment(name: "testFragment", type: "TestObject", fields: [Field(name: "id")])) =>
     
     "fragment testFragment on TestObject {
          id
     }"
     
     "fragment testFragment2 on TestObject {
          id
     }"
     ```
     */
    public override func visit(_ fragments: [Fragment]) -> String {
        var finishedString = ""
        
        for fragment in fragments {
            finishedString.append(visit(fragment))
        }
        
        return finishedString
    }

    /**
     Creates a string for Values.
     
     ``` swift
        visit(.int(1))                              => "1"
        visit(.double(1))                           => "1.0"
        visit(.string("hello"))                     => "\"hello\""
        visit(.null)                                => "null"
        visit(.enumeration("hello world"))          => "hello"
        visit(.list([.int(1), .string("hello")])    => "[1, \"hello\"]"
        visit(.object(["hello": .string("hello)])   => "{hello: 1.0}"
        visit(.variable("hello"))                   => "$hello"
     ```
     */
    public override func visit(_ value: Value) -> String {
        switch value {
        case .int(let int):
            return "\(int)"

        case .double(let double):
            return "\(double)"

        case .string(let string):
            return "\"\(string)\""

        case .boolean(let bool):
            return "\(bool)"

        case .null:
            return "null"

        case .enumeration(let string):
            return string

        case .list(let list):
            return makeReadableString(valueList: list)

        case .object(let object):
            return makeReadableString(object: object)

        case .variable(let variable):
            return "$\(variable.key)"
        }
    }

    /**
     Create a VariableDefinition String

     ``` swift
     visit(VariableDefinition(key: "hello", 
                              type: String", 
                              notNullable: true, 
                              value: .string("Hello!")) => "$testString: String!"
     ```
     */
    public override func visit(_ variableDefinition: VariableDefinition) -> String {
        return "$\(variableDefinition.key): \(variableDefinition.type)\(variableDefinition.notNullable ? "!" : "")"
    }

    /**
     Create a QueryOperation String

     ``` swift
     visit(QueryOperation(name: "ProductList", 
                          fields: [Field(name: "products", subfields: [Field(name: "id"), Field(name: "name"])])) =>

     "query ProductList {
         products {
             id,
             name
         }
     }"
     ```
     */
    public override func visit(_ queryOperation: QueryOperation) -> String {
        var finishedString = ""

        if let name = queryOperation.name {
            finishedString.append(queryOperation.mutating ? "mutation " : "query ")

            finishedString.append(name)

            if let variableDefinitions = queryOperation.variableDefinitions {
                finishedString.append(makeReadableString(variableDefinitionList: variableDefinitions))
            }

            finishedString.append(" ")
        }

        finishedString.append("{\n")

        finishedString.append(makeReadableString(fieldList: queryOperation.fields, atDepth: 0))

        finishedString.append("\n}")

        return finishedString
    }

    private func space(string: inout String, toDepth depth: Int) {
        for _ in 0..<depth {
            string.append("\t")
        }
    }
}
