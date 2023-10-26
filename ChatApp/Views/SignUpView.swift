//
//  SignUpView.swift
//  ChatApp
//
//  Created by admin on 25/10/2023.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    
    @State private var email:String = ""
    @State private var password:String = ""
    @State private var dispalyName:String = ""
    @State private var errorMessage:String = ""
    
    @EnvironmentObject private var  model:Model
    @EnvironmentObject private var appState:AppState
    
    private var isFormValid:Bool {
        !email.isEmptyOrWhiteSpace && !password.isEmptyOrWhiteSpace && !dispalyName.isEmptyOrWhiteSpace
    }
    
    private func signUp() async {
        do {
           let result = try await Auth.auth().createUser(withEmail: email, password: password)
           try await model.updateDisplayName(user: result.user, displayName: dispalyName)
            appState.routes.append(.login)
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
                TextField("Display Name", text: $dispalyName)
                
                HStack {
                    Spacer()
                    Button("Sign up"){
                        Task{
                            await signUp()
                        }
                    }.disabled(!isFormValid).buttonStyle(.borderless)
                    
                    Button("Login"){
                        appState.routes.append(.login)
                    }.buttonStyle(.borderless)
                    Spacer()
                }
            }
            
            Text(errorMessage)
                .foregroundColor(Color.red)
            
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(Model())
            .environmentObject(AppState())
    }
}
