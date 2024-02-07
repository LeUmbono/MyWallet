//
//  AddAccountView.swift
//  MyWallet
//
//  Created by Russell Umboh on 2/6/24.
//

import SwiftUI

struct AddAccountView: View {
    @EnvironmentObject var userModel: UserModel
    @State var accountName: String = ""
    @State var navigateToHome: Bool = false
    var body: some View {
        VStack {
            TextField("", text: $accountName)
                .textFieldStyle(.roundedBorder)
            Button {
                Task {
                    await userModel.createAccount(name: accountName)
                    navigateToHome = true
                }
            } label: {
                Text("Create")
                    .bold()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationDestination(isPresented: $navigateToHome)
        {
            HomeView()
        }
    }
}

#Preview {
    AddAccountView()
        .environmentObject(UserModel())
}
