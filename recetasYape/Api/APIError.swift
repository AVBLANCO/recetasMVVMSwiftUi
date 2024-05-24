//
//  APIError.swift
//  recetasYape
//
//  Created by Sergio Luis Noriega Pita on 15/05/24.
//

import Foundation


enum APIError: LocalizedError {
    case responseUnsuccessful
    case decodingFailure
    case custom(description: String)

    static func map(_ error: Error) -> APIError {
        return (error as? APIError) ?? .custom(description: error.localizedDescription)
    }
}
