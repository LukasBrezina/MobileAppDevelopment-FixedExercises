//
//  ContentView.swift
//  FixedExercises
//
//  Created by Lukas Brezina on 21.09.26.
//

import SwiftUI

struct ContentView: View {
    
    private let expectedEmail = "hcw@test.com"
    private let expectedPassword = "hcwPass123"

    @State
    private var email = ""
    
    @State
    private var password = ""
    
    @State
    private var alertTitle = ""
    
    @State
    private var alertContent = ""
    
    @State
    private var alertActive = false
    
    @State
    private var isLoading = false
    
    private let minHeight: CGFloat = 40
    
    private enum Field {
        case email
        case password
    }
    
    @FocusState
    private var focusedField: Field?
    

    var body: some View {
        
        HStack {
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
                
                HStack {
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
                }
                
                
                Spacer()
            }
            .disabled(isLoading)
            .padding()
        }
        .alert(
            alertTitle,
            isPresented: $alertActive) {
                Button("OK", role: .cancel) {
                    isLoading = false
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            if (email == expectedEmail && password == expectedPassword) {
                alertTitle = "Success"
                alertContent = "Successful Login"
            } else {
                alertTitle = "Error"
                alertContent = "Wrong Email and/or Password"
            }
            alertActive = true
        }
    }
}

#Preview { ContentView() }
