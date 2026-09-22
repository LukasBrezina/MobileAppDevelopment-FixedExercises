//
//  NetworkError.swift
//  FixedExercises
//
//  Created by Lukas Brezina on 21.09.26.
//

enum NetworkError: Error {
    case serializationError
    case invalidEmail
    case wrongEmail
    case invalidCredentials
    case noNetworkConnection
    case unexpectedHttpFormat
    case internalServerError
    case unexpectedError
}
