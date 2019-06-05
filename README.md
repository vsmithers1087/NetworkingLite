# NetworkingLite

A complete networking library written with Foundation with **less than 70 lines** of code.

## Inspiration

How many times have you needed to setup basic networking in a simple project or proof of concept, but ended up writing the same basic networking implementation over and over again?  

I wanted a reusable example showing that 3rd party networking dependencies are not necessary anymore. With the latest versions of Swift, it is much easier to create a custom solution, and forego adding thousands of lines of unneeded dependencies, while still abstracting networking responsibilities.

The easiest way to get setup is to install the library with SPM. Alternativley, this project is small enough so that you can download the source files and write your own networking library.

## Usage

Create an `enum` with a case for each networking route in project.
```swift
enum Services {
    case getMonkeys
    case createMonkey(name: String, age: Int)
}
```
Extend enum for `WebServiceConfiguration` conformance. Here is where you set the endpoints, method, headers and body for each route.
```swift
extension Services: WebServiceConfiguration {
    var baseURLString: String {
        return "localhost:8080"
    }
    var endpoint: String {
        switch self {
        case .getMonkeys:
            return baseURLString + "/" + "hello"
        case .createMonkey(_,_):
            return baseURLString + "/" + "createMonkey"
        }
    }
    
    var method: WebRequestMethod {
        switch self {
        case .getMonkeys:
            return .GET
        case .createMonkey(_,_):
            return .POST
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var httpBody: Data? {
        switch self {
        case .getMonkeys:
            return nil
        case .createMonkey(let name, let age):
            let body: [String: Any] = ["name": name, "age": age]
            let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [])
            return jsonData
        }
    }
}
```
Create an instance of `NetworkingLiteClient` of enum type outlining routes
```swift
let networkingLiteClient = NetworkingLiteClient<Services>()
networkingLiteClient.makeRequest( .getMonkeys) { (result) in
    switch result {
    case .success(let response):
        // Serialize response.data
    case .error(let error):
        // Handle error
    }
}
```
