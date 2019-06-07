# NetworkingLite

A networking package written with Foundation with **less than 70 lines** of code.

## Inspiration

I cannot count the number of times I have needed to setup basic networking in a simple project or proof of concept, but ended up writing the same basic networking implementation over and over again.

I wanted a reusable example showing that 3rd party networking dependencies are not necessary anymore. With the latest versions of Swift, it is much easier to create a custom solution, and forego adding thousands of lines of unneeded dependencies, while still abstracting networking responsibilities.

The easiest way to get setup is to install the library with SPM. Alternativley, this project is small enough so that you can download the source files and write your own networking library.

## Usage

Create an `enum` with a case for each networking route.
```swift
enum WebServices {
    case httpBinGET
    case httpBinBytes(bytes: Int)
    case httpBinUpload(data: Data)
    case httpBinAuthenticate(username: String, password: String)
    case httpBinDELETE
    case httpBinPUT
    case httpInvalid
}
```

Extend the routes enum for `WebServiceConfiguration` conformance. Here is where you set the endpoints, method, headers and body for each route.
```swift
extension WebServices: WebServiceConfiguration {

    var baseURLString: String {
        return "https://httpbin.org/"
    }

    var endpoint: String {
        let path: String
        switch self {
        case .httpBinGET:
            path = "get"
        case .httpBinBytes(let bytes):
            path = "bytes/\(bytes)"
        case .httpBinUpload(_):
            path = "post"
        case .httpBinAuthenticate(let username, let password):
            path = "basic-auth/\(username)/\(password)"
        case .httpBinDELETE:
            path = "delete"
        case .httpBinPUT:
            path = "put"
        case .httpInvalid:
            path = "invalid"
        }
        return baseURLString + path
    }

    var method: WebRequestMethod {
        switch self {
        case .httpBinGET,
        .httpBinBytes(_),
        .httpBinAuthenticate(_, _),
        .httpInvalid:
            return .GET
        case .httpBinUpload(_):
            return .POST
        case .httpBinDELETE:
            return .DELETE
        case .httpBinPUT:
            return .PUT
        }
    }

    var headers: [String : String]? {
        return ["accept": "application/json"]
    }

    var httpBody: Data? {
        switch self {
        case .httpBinGET,
        .httpBinBytes(_),
        .httpBinAuthenticate(_, _),
        .httpBinDELETE,
        .httpBinPUT,
        .httpInvalid:
            return nil
        case .httpBinUpload(let data):
            return data
        }
    }
}
```
Create an instance of `NetworkingLiteClient` with the routes enum that conforms to `WebServiceConfiguration`. It is important to keep `networkingLiteClient` as a stored property as oppossed to creating it in the scope of a function where it can be deallocated too early.
```swift
let networkingLiteClient = NetworkingLiteClient<WebServices>()
networkingLiteClient.makeRequest( .httpBinGET) { (result) in
    switch result {
    case .success(let response):
        // Serialize response.data
    case .error(let error):
        // Handle error
    }
}
```
