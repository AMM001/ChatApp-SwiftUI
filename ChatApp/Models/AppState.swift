//
//  AppState.swift
//  ChatApp
//
//  Created by admin on 25/10/2023.
//

import Foundation

enum Route {
    case mainScreen
    case login
    case signUp
}

class AppState: ObservableObject {
    @Published var routes:[Route] = []
}
