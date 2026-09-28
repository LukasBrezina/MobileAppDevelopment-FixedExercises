//
//  LoginView.swift
//  FixedExercises
//
//  Created by Lukas Brezina on 28.09.26.
//
import SwiftUI

struct LoginView: View {
    
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
    
    @State
    private var loginSuccess = false
    
    private let minHeight: CGFloat = 40
    
    private let apiClient = APIClient()
    
    private enum Field {
        case email
        case password
    }
    
    @FocusState
    private var focusedField: Field?
    
    @State
    var user: User?
    

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
            .navigationDestination(isPresented: $loginSuccess, destination: {
                CountriesView(loginIdToken: user?.idToken ?? "")
            })
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
        
        APIClient.shared.login(username: email, password: password) { user, error in
            isLoading = false
            if let error {
                alertTitle = "Error"
                alertContent = errorMessage(error: error)
                loginSuccess = false
                alertActive = true
            } else if user != nil {
                self.user = user
                loginSuccess = true
            }
        }
    }
    
    private func errorMessage(error: NetworkError) -> String {
        switch error {
        case .internalServerError: "Internal Server Error"
        case .serializationError: "Serialization Error"
        case .invalidEmail: "Invalid Email"
        case .wrongEmail: "No account found for this email"
        case .invalidCredentials: "Invalid Credentials"
        case .invalidApiUrl: "Invalid API URL"
        case .noNetworkConnection(let text): "No Network Connection: \(text)"
        case .unexpectedHttpFormat(let code): "Unexpected response format (status \(code))"
        case .httpError(let code, let message): "Request failed (status \(code)): \(message ?? "unknown")"
        case .unexpectedError(let text): "Unexpected Error: \(text)"
        }
    }
}
