//
//  File.swift
//  
//
//  Created by Vincent Smithers on 06.06.19.
//

import Foundation
@testable import NetworkingLite

enum WebServicesMock {
    case httpBinGET
    case httpBinBytes(bytes: Int)
    case httpBinUpload(data: Data)
    case httpBinAuthenticate(username: String, password: String)
    case httpBinDELETE
    case httpBinPUT
    case httpInvalid
}

extension WebServicesMock: WebServiceConfiguration {
    
    var baseURLString: String {
        "https://httpbin.org/"
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
