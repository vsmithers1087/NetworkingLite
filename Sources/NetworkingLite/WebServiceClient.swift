//
//  File.swift
//  
//
//  Created by Vincent Smithers on 04.06.19.
//

import Foundation

public protocol WebServiceClient: class {
    associatedtype WebServiceConfig: WebServiceConfiguration
    func makeRequest(webServiceConfig: WebServiceConfig, result: @escaping (WebRequestResult) -> Void )
}
