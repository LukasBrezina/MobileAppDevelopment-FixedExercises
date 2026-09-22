//
//  ContentView.swift
//  FixedExercises
//
//  Created by Lukas Brezina on 21.09.26.
//

import SwiftUI

struct ContentView: View {

    @State
    private var username = ""
    
    @State
    private var password = ""
    

    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text("Login")
                .font(.largeTitle)
                .bold()
            

            TextField("Username", text: $username)
                .textInputAutocapitalization(.never)
                .textContentType(.username)
                .autocorrectionDisabled()
                .font(.title2)
                .padding(24)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)

            SecureField("Password", text: $password)
                .textContentType(.password)
                .font(.title2)
                .padding(24)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            
            Spacer()
            
            Button {
                print("Login")
            } label: {
                Text("Login")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
