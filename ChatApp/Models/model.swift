//
//  model.swift
//  ChatApp
//
//  Created by admin on 25/10/2023.
//

import Foundation
import FirebaseAuth

@MainActor
class Model:ObservableObject {
    
    func updateDisplayName(user:User , displayName:String) async {
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        try? await request.commitChanges()
    }
}
