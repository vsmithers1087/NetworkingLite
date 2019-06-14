//
//  File.swift
//  
//
//  Created by Vincent Smithers on 04.06.19.
//

import Foundation

public struct WebRequestError {
    public let statusCode: Int
    public let error: Error?
}
