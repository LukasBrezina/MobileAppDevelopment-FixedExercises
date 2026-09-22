//
//  APIClient.swift
//  FixedExercises
//
//  Created by Lukas Brezina on 21.09.26.
//

import Foundation

class APIClient {
    
    private let session = URLSession(configuration: .default)
    private let apiKey = ""
    
    func login(username: String,
               password: String,
               completionHandler: @escaping (User?, NetworkError?) -> Void) {
        
        guard let url = URL(string: "") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content/Type")
        
        let body: [String: Any] = [
            "email" : username,
            "password" : password,
            "returnSecureToken": true
        ]
        
        let data = try! JSONSerialization.data(withJSONObject: body)
        
        request.httpBody = data
        
        let dataTask = session.dataTask(with: request) { data, urlResponse, error in
        
            if let data {
                if let response = urlResponse as? HTTPURLResponse, response.statusCode != 200 {
                    DispatchQueue.main.async {
                        let error: ResponseError = try! JSONDecoder().decode(ResponseError.self, from: data)
                        
                        completionHandler(nil, error.getNetworkError())
                        
                    }
                } else {
                    DispatchQueue.main.async {
                        let user: User = try! JSONDecoder().decode(User.self, from: data)
                        
                        completionHandler(user, nil)
                    }
                }
            }
            
        }
        
        dataTask.resume()
        
    }
    
}
