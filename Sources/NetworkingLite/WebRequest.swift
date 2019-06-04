//
//  File.swift
//  
//
//  Created by Vincent Smithers on 04.06.19.
//

import Foundation

final class WebRequest {
    
    private var urlRequest: URLRequest
    private var backgroundSession: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue())
        return session
    }
    
    init(endpoint: String, method: WebRequestMethod, headers: [String: String]?, httpBody: Data? = nil) {
        guard let url = URL(string: endpoint) else {
            fatalError("Cannot create WebRequest URL from endpoint")
        }
        urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = httpBody
    }
    
    func execute(result: @escaping (WebRequestResult) -> Void) {
        backgroundSession.dataTask(with: urlRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let response = response as? HTTPURLResponse, let data = data else {
                result(.error(WebRequestError(statusCode: 0, error: error)))
                return
            }
            guard 200...299 ~= response.statusCode else {
                let error = WebRequestError(statusCode: response.statusCode, error: error)
                result(.error(error))
                return
            }
            result(.success(WebRequestSuccessResponse(response: response, data: data)))
        }).resume()
    }
}
