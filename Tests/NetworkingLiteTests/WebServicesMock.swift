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
    case httpBinStream(numberOfLines: Int)
    case httpBinBytes(bytes: Int)
    case httpBinUpload(data: Data)
    case httpBinAuthenticate(username: String, password: String)
    case httpBinDELETE
    case httpBinPUT
}

extension WebServicesMock: WebServiceConfiguration {
    var baseURLString: String {
        "https://httpbin.org/"
    }
    
    var endpoint: String {
        switch self {
        case .httpBinGET:
            return "get"
        case .httpBinStream(let numberOfLinse):
            return "stream/\(numberOfLinse)"
        case .httpBinBytes(let bytes):
            return "bytes/\(bytes)"
        case .httpBinUpload(_):
            return "post"
        case .httpBinAuthenticate(let username, let password):
            return "basic-auth/\(username)/\(password)"
        case .httpBinDELETE:
            return "delete"
        case .httpBinPUT:
            return "put"
        }
    }
    
    var method: WebRequestMethod {
        switch self {
        case .httpBinGET, .httpBinStream(_), .httpBinBytes(_), .httpBinAuthenticate(_, _):
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
             .httpBinStream(_),
             .httpBinBytes(_),
             .httpBinAuthenticate(_, _),
             .httpBinDELETE,
             .httpBinPUT:
            return nil
        case .httpBinUpload(let data):
            return data
        }
    }
}
