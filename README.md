# Stardaze
## A Swift GraphQL Serializer

Stardaze was born out of a need to create GraphQL queries in a typesafe way in Swift applications.
View the GraphQL spec [here](https://facebook.github.io/graphql).

### Approaching this Library:
View the example playground for detailed usage examples. If you are unfamiliar with GraphQL, start by looking
at `Field`. From there, move on to `QueryOperation` and `Document`.

### Example Usage:

``` swift
let productList = Field(name: "product_list", alias: "productList")
    .appended(argument: Argument(key: "is_awesome", value: true))
	.appended(argument: Argument(key: "color", value: Color.blue))
    .appended(subFields: ["id", "title"])

let queryOperation = QueryOperation(fields: [productList])
let document = Document(queryOperation: queryOperation)

print(document.stringify(encoded: false))
// {
//     productList: product_list(is_awesome: true, color: blue) {
//         id
//         title
//     }
// }

print(document.stringify(encoded: true))
// query=%7B%0A%09productList%3A%20product_list%28is_awesome%3A%20true%29%20%7B%0A%09%09id%0A%09%09title%0A%09%7D%0A%7D

let parametersDictionary = document.parameterize(encoded: false)

print(parametersDictionary["query"])
// { productList: product_list(is_awesome: true) { id title } }

```

