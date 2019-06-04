//
//  File.swift
//  
//
//  Created by Vincent Smithers on 04.06.19.
//

import Foundation

final class NetworkingLiteClient<WebService: WebServiceConfiguration>: WebServiceClient {
    func makeRequest(forWebService webService: WebService, result: @escaping (WebRequestResult) -> Void ) {
        let webRequest = WebRequest(endpoint: webService.endpoint, method: webService.method, headers: webService.headers, httpBody: webService.httpBody)
        webRequest.execute(result: result)
    }
}
