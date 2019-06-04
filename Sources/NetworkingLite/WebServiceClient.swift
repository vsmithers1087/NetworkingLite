//
//  File.swift
//  
//
//  Created by Vincent Smithers on 04.06.19.
//

import Foundation

protocol WebServiceClient: class {
    associatedtype WebService: WebServiceConfiguration
    func makeRequest(forWebService webService: WebService, result: @escaping (WebRequestResult) -> Void )
}
