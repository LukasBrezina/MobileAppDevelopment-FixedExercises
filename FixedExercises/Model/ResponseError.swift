//
//  ResponseError.swift
//  FixedExercises
//
//  Created by Lukas Brezina on 21.09.26.
//
import Foundation

struct ResponseError: Codable {
    let error: InlineError
    
    func getNetworkError(statusCode: Int) -> NetworkError {
        switch error.message {
        case "INVALID_EMAIL": return .invalidEmail
        case "EMAIL_NOT_FOUND": return .wrongEmail
        case "INVALID_PASSWORD", "INVALID_LOGIN_CREDENTIALS": return .invalidCredentials
        default: return .httpError(statusCode: statusCode, message: error.message)
        }
    }
    
}

struct InlineError: Codable {
    let code: Int
    let message: String
    let errors: [Errors]
}

struct Errors: Codable {
    let message: String
    let domain: String
    let reason: String
}

