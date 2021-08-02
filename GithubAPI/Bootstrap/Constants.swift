//
//  Constants.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 7/28/21.
//

import Foundation

// MARK: - DEBUGGING UTILS
enum GithubAPIApp {
    static let debugUtilsEnabled = false
}


// MARK: - Standardized Error Messages
enum APIErrors: Error {
    case fetchError
    case unprocessableData
    case queryTimeout
    case validationFailed
    case invalidRequestUrl
}
