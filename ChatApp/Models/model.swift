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
    @Published var chatMessages: [ChatMessage] = []
    
    var firestoreListener: ListenerRegistration?
    
    func updateDisplayName(user:User , displayName:String) async {
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        try? await request.commitChanges()
    }
    
    func updatePhotoURL(for user: User, photoURL: URL) async throws {
        
        let request = user.createProfileChangeRequest()
        request.photoURL = photoURL
        try await request.commitChanges()
        
        // update UserInf for all messages
        
    }
    
    func detachFirebaseListener() {
        self.firestoreListener?.remove()
    }
    
    func listenForChatMessages(in group: Group) {
        
        let db = Firestore.firestore()
        
        chatMessages.removeAll()
        
        guard let documentId = group.documentId else { return }
        
        self.firestoreListener = db.collection("groups")
            .document(documentId)
            .collection("messages")
            .order(by: "dateCreated", descending: false)
            .addSnapshotListener({ [weak self] snapshot, error in
                
                guard let snapshot = snapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                
                snapshot.documentChanges.forEach { diff in
                    if diff.type == .added {
                        let chatMessage = ChatMessage.fromSnapshot(snapshot: diff.document)
                        if let chatMessage {
                            let exists = self?.chatMessages.contains(where: { cm in
                                cm.documentId == chatMessage.documentId
                            })
                            
                            if !exists! {
                                self?.chatMessages.append(chatMessage)
                            }
                        }
                    }
                }
                
            })
        
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
    
    
    func saveChatMessageToGroup(chatMessage: ChatMessage, group: Group) async throws {
        
        let db = Firestore.firestore()
        guard let groupDocumentId = group.documentId else { return }
        let _ = try await db.collection("groups")
            .document(groupDocumentId)
            .collection("messages")
            .addDocument(data: chatMessage.toDictionary())
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
