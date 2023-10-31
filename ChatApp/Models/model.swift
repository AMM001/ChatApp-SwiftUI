//
//  model.swift
//  ChatApp
//
//  Created by admin on 25/10/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
//import FirebaseFirestoreSwift

@MainActor
class Model:ObservableObject {
    
    @Published var groups:[Group] = []
    
    func updateDisplayName(user:User , displayName:String) async {
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        try? await request.commitChanges()
    }
    
    func populateGroups() async throws {
        
        let db = Firestore.firestore()
        let snapshot = try await db.collection("groups")
            .getDocuments()
        
        groups = snapshot.documents.compactMap { snapshot in
            // we need to get a group based on snapshot
            Group.fromSnapshot(snapshot:snapshot)
        }
        
    }
    
    func saveGroup(group:Group , completion:@escaping (Error?) -> Void ){
        let db = Firestore.firestore()
        let docRef:DocumentReference? = nil
        db.collection("groups")
            .addDocument(data: group.todictionary()) { [weak self] error in
                if error != nil {
                    completion(error)
                }else{
                    if let docRef {
                        var newGroup = group
                        newGroup.documentId = docRef.documentID
                        self?.groups.append(newGroup)
                        completion(nil)
                    }else{
                        completion(nil)
                    }
                }
            }
    }
}
