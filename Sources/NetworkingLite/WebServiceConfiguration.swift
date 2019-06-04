//
//  File.swift
//  
//
//  Created by Vincent Smithers on 04.06.19.
//

import Foundation

protocol WebServiceConfiguration {
    var baseURLString: String { get }
    var endpoint: String { get }
    var method: WebRequestMethod { get }
    var headers: [String: String]? { get }
    var httpBody: Data? { get }
}
