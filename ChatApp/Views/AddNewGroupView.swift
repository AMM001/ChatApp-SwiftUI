//
//  AddNewGroupView.swift
//  ChatApp
//
//  Created by admin on 26/10/2023.
//

import SwiftUI

struct AddNewGroupView: View {
    
    @Environment (\.dismiss) private var dismiss
    @EnvironmentObject private var model:Model
    @State private var groupSubject = ""
    private var isFormValid:Bool {
        !groupSubject.isEmptyOrWhiteSpace
    }
    
    private func saveGroup(){
        let group = Group(subject: groupSubject)
        model.saveGroup(group: group) { error in
            if let error {
                print(error.localizedDescription)
            }
            dismiss()
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("new Group", text:$groupSubject)
                }
                Spacer()
                    .toolbar {
                        ToolbarItem(placement: .principal){
                            Text("New Group")
                                .bold()
                        }
                        ToolbarItem(placement: .navigationBarLeading){
                            Button("cancel"){
                                dismiss()
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button("create"){
                                saveGroup()
                                
                            }.disabled(!isFormValid)
                        }
                    }
            }.padding()
        }
    }
}

struct AddNewGroupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddNewGroupView()
                .environmentObject(Model())
        }
    }
}
