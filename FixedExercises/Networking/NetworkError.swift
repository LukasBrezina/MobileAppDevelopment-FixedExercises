//
//  NetworkError.swift
//  FixedExercises
//
//  Created by Lukas Brezina on 21.09.26.
//

enum NetworkError: Error {
    case internalServerError
    case serializationError
    case invalidEmail
    case wrongEmail
    case invalidCredentials
    case invalidApiUrl
    case noNetworkConnection(String)
    case unexpectedHttpFormat(Int)
    case httpError(statusCode: Int, message: String?)
    case unexpectedError(String)
}
