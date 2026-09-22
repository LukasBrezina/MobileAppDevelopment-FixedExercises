//
//  ResponseError.swift
//  FixedExercises
//
//  Created by Lukas Brezina on 21.09.26.
//

struct ResponseError: Decodable {
    
    struct InlineError: Decodable {
        
        struct Errors: Decodable {
            // TODO: add fields
        }
        
        let code: Int
        let message: String
        let errors: [Errors]
        
        init(code: Int, message: String, errors: [Errors]) {
            self.code = code
            self.message = message
            self.errors = errors
        }
        
    }
    
    let error: InlineError
    
    init(error: InlineError) {
        self.error = error
    }

    func getNetworkError() -> NetworkError {
        switch error.message {
            case "INVALID_LOGIN_CREDENTIALS":
                return .invalidCredentials
            case "INVALID_EMAIL":
                return .invalidEmail
            default:
                return .unexpectedError
            }
        // TODO: other errors
    }
}
