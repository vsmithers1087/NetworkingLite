//
//  File.swift
//  
//
//  Created by Vincent Smithers on 04.06.19.
//

import Foundation

/// Object that abstracts network requests. Initialize and store instance in location that won't be deallocated; don't initialize class in function scope
final public class NetworkingLiteClient<WebServiceConfig: WebServiceConfiguration>: WebServiceClient {
    
    /// Makes request for type that conforms to `WebServiceConfiguration`
    /// - Parameter webServiceConfig: The associated type containing all request cases. Request case declared when method is called
    /// - Parameter result: Type `WebRequestResult` consisting of `success` and `error`
    public func makeRequest(webServiceConfig: WebServiceConfig, result: @escaping (WebRequestResult) -> Void ) {
        let webRequest = WebRequest(endpoint: webServiceConfig.endpoint, method: webServiceConfig.method, headers: webServiceConfig.headers, httpBody: webServiceConfig.httpBody)
        webRequest.execute { (webRequestResult) in
            DispatchQueue.main.async {
                result(webRequestResult)
            }
        }
    }
}
