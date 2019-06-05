//
//  File.swift
//  
//
//  Created by Vincent Smithers on 04.06.19.
//

import Foundation

public enum WebRequestResult {
    case success(WebRequestSuccessResponse)
    case error(WebRequestError)
}
