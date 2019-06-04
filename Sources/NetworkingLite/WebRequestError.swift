//
//  File.swift
//  
//
//  Created by Vincent Smithers on 04.06.19.
//

import Foundation

struct WebRequestError {
    let statusCode: Int
    let error: Error?
}