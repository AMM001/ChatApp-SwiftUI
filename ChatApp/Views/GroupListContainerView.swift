//
//  GroupListContainerView.swift
//  ChatApp
//
//  Created by admin on 26/10/2023.
//

import SwiftUI

struct GroupListContainerView: View {
    
    @State private var ispresented:Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("new group"){
                    ispresented = true
                }
            }
            Spacer()
        }.padding()
            .sheet(isPresented: $ispresented) {
                AddNewGroupView()
            }
    }
}

struct GroupListContainerView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListContainerView()
    }
}
