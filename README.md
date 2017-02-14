# Gorilla Query Language
## A Swift GraphQL Serializer

Gorilla Query Language was born out of a need to create GraphQL queries in a typesafe way in Swift applications.
View the GraphQL spec [here](https://facebook.github.io/graphql).

### Approaching this Libray:
The best way to start if you are unfamiliar with GraphQL is by looking at `Field`. From there, move on to 
`QueryOperation` and `Document`.

### Example Usage:

``` swift
var productList = Field(name: "product_list", alias: "productList")

productList.append(argument: Argument(key: "is_awesome", value: .boolean(true)))

productList.append(subFields: [
	Field(name: "id"),
	Field(name: "title")
	])

let queryOperation = QueryOperation(fields: [productList])
let document = Document(queryOperation: queryOperation)

print(document.userRepresenation())
// {
//     productList: product_list(is_awesome: true) {
//         id
//         title
//     }
// }

print(document.encodedRepresentation())
// query=%7B%0A%09productList%3A%20product_list%28is_awesome%3A%20true%29%20%7B%0A%09%09id%0A%09%09title%0A%09%7D%0A%7D

```
