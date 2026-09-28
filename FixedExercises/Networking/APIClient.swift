//
//  APIClient.swift
//  FixedExercises
//
//  Created by Lukas Brezina on 21.09.26.
//

import Foundation

class APIClient {
    
    static let shared = APIClient()
    
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

            if let error {
                networkError = .noNetworkConnection(error.localizedDescription)
            } else if let data, let http = urlResponse as? HTTPURLResponse {
                if (200...299).contains(http.statusCode) {
                    user = try? JSONDecoder().decode(User.self, from: data)
                    if user == nil { networkError = .unexpectedHttpFormat(http.statusCode) }
                } else if let responseError = try? JSONDecoder().decode(ResponseError.self, from: data) {
                    networkError = responseError.getNetworkError(statusCode: http.statusCode)
                } else {
                    networkError = .httpError(statusCode: http.statusCode, message: nil)
                }
            } else {
                networkError = .unexpectedError("No data or response")
            }

            DispatchQueue.main.async {
                completionHandler(user, networkError)
            }
        }
        dataTask.resume()
        
    }
    
    func countries (pageSize: Int = 1000, orderBy: String = "name", loginIdToken: String, completionHandler: @escaping (Countries?, NetworkError?) -> Void) {
        
        guard let url = URL(string: "https://firestore.googleapis.com/v1/projects/mad-fe/databases/(default)/documents/countries?pageSize=1000&orderBy=name") else {
            completionHandler(nil, .invalidApiUrl)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(loginIdToken)", forHTTPHeaderField: "Authorization")
        

        let dataTask = session.dataTask(with: request) { data, urlResponse, error in
            var countries: Countries?
            var networkError: NetworkError?

            if let error {
                networkError = .noNetworkConnection(error.localizedDescription)
            } else if let data, let http = urlResponse as? HTTPURLResponse {
                if (200...299).contains(http.statusCode) {
                    countries = try? JSONDecoder().decode(Countries.self, from: data)
                } else if let responseError = try? JSONDecoder().decode(ResponseError.self, from: data) {
                    networkError = responseError.getNetworkError(statusCode: http.statusCode)
                } else {
                    networkError = .internalServerError
                }
            } else {
                networkError = .unexpectedError("No data or response")
            }

            DispatchQueue.main.async {
                completionHandler(countries, networkError)
            }
        }
        
        dataTask.resume()
        
        
        
    }
    
}
