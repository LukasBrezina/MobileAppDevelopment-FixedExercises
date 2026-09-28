//
//  ResponseError.swift
//  FixedExercises
//
//  Created by Lukas Brezina on 21.09.26.
//
import Foundation

nonisolated struct ResponseError: Codable {
    let error: InlineError
    
    func getNetworkError() -> NetworkError {
            switch error.message {
            case "INVALID_EMAIL": return .invalidEmail
            case "EMAIL_NOT_FOUND": return .wrongEmail
            case "INVALID_PASSWORD", "INVALID_LOGIN_CREDENTIALS": return .invalidCredentials
            default: return .unexpectedError
            }
        }
    
}

nonisolated struct InlineError: Codable {
    let code: Int
    let message: String
    let errors: [Errors]
}

nonisolated struct Errors: Codable {
    let message: String
    let domain: String
    let reason: String
}

