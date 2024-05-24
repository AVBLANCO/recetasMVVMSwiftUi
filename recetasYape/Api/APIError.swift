//
//  APIError.swift
//  recetasYape
//
//  Created by Sergio Luis Noriega Pita on 15/05/24.
//

import Foundation


enum APIError: LocalizedError {
    case unknown
    case apiError(reason: String)
    case parsingError(reason: String)
    case networkError(reason: String)
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .apiError(let reason):
            return reason
        case .parsingError(let reason):
            return reason
        case .networkError(let reason):
            return reason
        }
    }
}
