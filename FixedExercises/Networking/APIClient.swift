//
//  APIClient.swift
//  FixedExercises
//
//  Created by Lukas Brezina on 21.09.26.
//

import Foundation

class APIClient {
    
    private let session = URLSession(configuration: .default)
    private let apiKey = "AIzaSyDeLs8S6Hpy642JUPC3Pft-xVx8Ocs-uXY"
    private var apiUrl: String {
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=\(apiKey)"
    }
    
    func login(username: String,
               password: String,
               completionHandler: @escaping (User?, NetworkError?) -> Void) {
        
        guard let url = URL(string: apiUrl) else {
            completionHandler(nil, .invalidApiUrl)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email" : username,
            "password" : password,
            "returnSecureToken": true
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completionHandler(nil, .serializationError)
            return
        }
        
        let dataTask = session.dataTask(with: request) { data, urlResponse, error in
            var user: User?
            var networkError: NetworkError?
            
            if error != nil {
                 networkError = .noNetworkConnection
             } else if let data, let http = urlResponse as? HTTPURLResponse {
                 if http.statusCode == 200 {
                     user = try? JSONDecoder().decode(User.self, from: data)
                     if user == nil { networkError = .unexpectedHttpFormat }
                 } else if let responseError = try? JSONDecoder().decode(ResponseError.self, from: data) {
                     networkError = responseError.getNetworkError()
                 } else {
                     networkError = .internalServerError
                 }
             } else {
                 networkError = .unexpectedError
             }
            
            DispatchQueue.main.async {
                completionHandler(user, networkError)
            }
        }
        
        dataTask.resume()
        
    }
    
}
