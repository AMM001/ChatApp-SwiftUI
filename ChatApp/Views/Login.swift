//
//  Login.swift
//  ChatApp
//
//  Created by admin on 25/10/2023.
//

import SwiftUI
import FirebaseAuth

struct Login: View {
    
    @State private var email:String = ""
    @State private var password:String = ""
    @State private var errorMessage:String = ""
    @EnvironmentObject private var appState:AppState
    
    private var isFormValid:Bool {
        !email.isEmptyOrWhiteSpace && !password.isEmptyOrWhiteSpace
    }
    
    private func login()async {
        
        do {
            try await  Auth.auth().signIn(withEmail: email, password: password)
            appState.routes.append(.mainScreen)
        }catch {
            errorMessage = error.localizedDescription
        }
    }
    
    var body: some View {
        VStack {
            Form {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                TextField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                HStack {
                    Spacer()
                    Button("Login"){
                        Task {
                            await login()
                        }
                    }.disabled(!isFormValid).buttonStyle(.borderless)
                    
                    Button("Register"){
                        appState.routes.append(.signUp)
                    }.buttonStyle(.borderless)
                    Spacer()
                    
                }
            }
            
            Text(errorMessage)
                .foregroundColor(Color.red)
            
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login().environmentObject(AppState())
    }
}
