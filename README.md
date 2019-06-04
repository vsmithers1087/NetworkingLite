# NetworkingLite

A complete networking library written with Foundation in less than 70 lines of code with Swift 5.1.

## Inspiration

How many times a year have you needed to setup basic networking in a simple project or proof of concept, but ended up writing the same basic networking implementation over and over again?  

Inspired by frameworks such as Alamofire and Moya, I wanted a usable example showing that 3rd party networking dependencies are not necessary with the latest version of Swift. These days it is much easier to create your own custom solution, and forego adding thousands of lines of unneeded dependencies, while still keeping the upside of abstracting networking responsibilities.

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
networkingLiteClient.makeRequest(forWebService: .getMonkeys) { (result) in
    switch result {
    case .success(let response):
        print("\(response.response) \(response.data)")
        let json = try? JSONSerialization.jsonObject(with: response.data, options: [])
        print(json)
    case .error(let error):
        print(error)
    }
}
```
