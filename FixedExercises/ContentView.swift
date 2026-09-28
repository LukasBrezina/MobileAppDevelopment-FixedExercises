//
//  ContentView.swift
//  FixedExercises
//
//  Created by Lukas Brezina on 21.09.26.
//

import SwiftUI

struct ContentView: View {

    @State
    private var email = "mad-fe@mad.at"
    
    @State
    private var password = "madmad"
    
    @State
    private var alertTitle = ""
    
    @State
    private var alertContent = ""
    
    @State
    private var alertActive = false
    
    @State
    private var isLoading = false
    
    private let minHeight: CGFloat = 40
    
    private let apiClient = APIClient()
    
    private enum Field {
        case email
        case password
    }
    
    @FocusState
    private var focusedField: Field?
    

    var body: some View {
        
        VStack {
                
            Spacer()
            
            Text("Login")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, minHeight: minHeight)
                .padding(24)
                .bold()
            
            
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .autocorrectionDisabled()
                .frame(maxWidth: .infinity, minHeight: minHeight)
                .font(.title2)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                .onSubmit {
                    focusedField = .password
                }
            
            SecureField("Password", text: $password)
                .textContentType(.password)
                .focused($focusedField, equals: .password)
                .submitLabel(.go)
                .frame(maxWidth: .infinity, minHeight: minHeight)
                .font(.title2)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                .onSubmit {
                    login()
                }
            
            Spacer()
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, minHeight: minHeight)
                    .padding()
            } else {
                Button {
                    login()
                } label: {
                    Text("Login")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: minHeight)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            
            Spacer()
        }
        .disabled(isLoading)
        .padding()
        .alert(
            alertTitle,
            isPresented: $alertActive) {
                Button("OK", role: .cancel) {
                    
                }
            } message: {
                Text(alertContent)
            }
    }
    
    func login() {
        
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertTitle = "Error"
            alertContent = "Email missing!"
            alertActive = true
            return
        }
        
        guard !password.isEmpty else {
            alertTitle = "Error"
            alertContent = "Password missing!"
            alertActive = true
            return
        }
        
        isLoading = true
        focusedField = nil
        
        apiClient.login(username: email, password: password) { user, error in
            isLoading = false
            if let error {
                alertTitle = "Error"
                alertContent = errorMessage(error: error)
            } else if user != nil {
                alertTitle = "Success"
                alertContent = "Successful Login"
            }
            alertActive = true
        }
    }
    
    private func errorMessage(error: NetworkError) -> String {
        
        switch error {
        case .internalServerError: return "Internal Server Error"
        case .invalidApiUrl: return "Invalid API URL"
        case .invalidCredentials: return "Invalid Credentials"
        case .invalidEmail: return "Invalid Email"
        case .noNetworkConnection: return "No Network Connection"
        case .serializationError: return "Serialization Error"
        default: return "Unexpected Error"
        }
    }
}

#Preview { ContentView() }
