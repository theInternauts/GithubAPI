//
//  Constants.swift
//  GithubAPI
//
//  Created by Christopher Wallace on 7/28/21.
//

import Foundation

// MARK: - DEBUGGING UTILS
enum GithubAPIApp {
    static let debugUtilsEnabled = true
}


// MARK: - Standardized Error Messages
enum APIErrors: Error {
    case fetchError
    case unprocessableData
    case queryTimeout
    case validationFailed
    case invalidRequestUrl
    
    var message: String {
      switch self {
      case .fetchError:
        return ""
      case .unprocessableData:
        return ""
      case .queryTimeout:
        return ""
      case .validationFailed:
        return ""
      case .invalidRequestUrl:
        return ""
      }
    }
}
