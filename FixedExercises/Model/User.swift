//
//  User.swift
//  FixedExercises
//
//  Created by Lukas Brezina on 21.09.26.
//

struct User: Codable {
    let kind: String
    let localId: String
    let email: String
    let idToken: String
    let registered: Bool
    let refreshToken: String
    let expiresIn: String
    
    init(kind: String, localId: String, email: String, idToken: String, registered: Bool, refreshToken: String, expiresIn: String) {
        self.kind = kind
        self.localId = localId
        self.email = email
        self.idToken = idToken
        self.registered = registered
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
    }
}
