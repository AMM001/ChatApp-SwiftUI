//
//  Group.swift
//  ChatApp
//
//  Created by admin on 30/10/2023.
//

import Foundation
import FirebaseFirestore


struct Group: Codable , Identifiable{
    var subject:String
    var documentId:String? = nil
    
    var id:String {
        documentId ?? UUID().uuidString
    }
}

extension Group {
    
    func todictionary()-> [String:String] {
        return ["subject":subject]
    }
    
    static func fromSnapshot(snapshot: QueryDocumentSnapshot) -> Group? {
        let dictionary = snapshot.data()
        guard let subject = dictionary["subject"] as? String else {
            return nil
        }
        
        return Group(subject: subject, documentId: snapshot.documentID)
    }
}
