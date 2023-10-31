//
//  GroupDetailView.swift
//  ChatApp
//
//  Created by admin on 31/10/2023.
//

import SwiftUI

struct GroupDetailView: View {
    
    let group: Group
    @EnvironmentObject private var model: Model
    @State private var chatText: String = ""
    
    var body: some View {
        VStack {
            
            Spacer()
            TextField("Enter chat message", text: $chatText)
            Button("Send") {
                model.saveChatMessageToGroup(text: chatText, group: group) { error in
                    
                }
            }
        }.padding()
    }
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView(group: Group(subject: "Movies"))
            .environmentObject(Model())
    }
}
