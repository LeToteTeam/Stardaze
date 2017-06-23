// Example Stardaze usage

import Stardaze

enum Color: String {
    case red
    case green
    case violet
}

func print(title: String, text: CustomStringConvertible) {
    print("\(title):")
    print(text)
    print("")
}

/**
 # Basic Usage
 
 * Create your fields using the optional alias parameter where needed.
 * Append arguments, directives, and subfields as needed.
 * Put the fields in a QueryOperation and put the QueryOperation in a Document.
 * Call either stringify or parameterize title or titleout encoding as is needed for your networking strategy.
 */
let productList = Field(name: "product_list", alias: "productList")
    .appended(argument: Argument(key: "color", value: Color.red))
    .appended(argument: Argument(key: "limit", value: 20))
    .appended(subField: "id")
    .appended(subField: "title")
    .appended(subField: Field(name: "photo", subFields: ["width", "height"]))

let productDocument = Document(queryOperation: QueryOperation(fields: [productList]))

print(title: "Readable String", text: productDocument.stringify(encoded: false))
print(title: "Encoded", text: productDocument.stringify(encoded: true))
print(title: "Parameters", text: productDocument.parameterize(encoded: false))
print(title: "Encoded Parameters", text: productDocument.parameterize(encoded: true))

/**
 # Using fragments
 
 * Create your fragments.
 * Use the fragment as needed in your fields.
 * When putting your query in your document, also put the fragments in your document
 */

let photoFragment = Fragment(name: "photoFragment", type: "Photo", fields: ["width", "height", "url"])
let identifiersFragment = Fragment(name: "identifierFragment", type: "Product", fields: ["id", "title"])

let fragmentedProductList = Field(name: "product_list", alias: "productList")
    .appended(fragment: identifiersFragment)
    .appended(subField: Field(name: "photos",
                              subFields: [Field(name: "medium_photo", alias: "mediumPhoto", fragments: [photoFragment]),
                                          Field(name: "large_photo", alias: "largePhoto", fragments: [photoFragment])]))

let fragmentedQuery = QueryOperation(name: "ProductList", fields: [fragmentedProductList])

let fragmentedDocument = Document(queryOperation: fragmentedQuery, fragments: [photoFragment, identifiersFragment])

print(title: "Fragemented Query", text: fragmentedDocument.stringify(encoded: false))

/**
 # Using variables
 
 * Create variables and variable definitions that specify the value of the variables.
 * Use the variables as needed in arguments on fields
 * When putting your fields into a query, put the associated variable definitions on the query as well.
 */

let count = Variable("counts")
let countsDefinition = VariableDefinition(key: "counts", type: "[Int]", notNullable: true, value: [23, 45])

let object = Variable("person")
let objectDefinition = VariableDefinition(key: "person", type: "Person", value: ["name": "John",
                                                                                 "age": 15])

let variableProductList = Field(name: "product_list",
                                arguments: [Argument(key: "count", value: count), Argument(key: "person", value: object)],
                                subFields: ["id", "title"])

let variableQuery = QueryOperation(name: "ProductList",
                                   variableDefinitions: [countsDefinition!, objectDefinition!],
                                   fields: [variableProductList])

let variableDocument = Document(queryOperation: variableQuery)

print(title: "Variable", text: variableDocument.stringify(encoded: false))

print(title: "blah", text: variableDocument.parameterize(encoded: false))

