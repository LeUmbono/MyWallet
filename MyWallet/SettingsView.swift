//
//  SettingsView.swift
//  MyWallet
//
//  Created by Russell Umboh on 1/31/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userModel: UserModel
    @State var nameString: String = ""
    @State var phoneNumber: String = ""
    var body: some View {
        VStack {
            Form {
                Section() {
                    TextField("Name", text: $nameString)
                    Text(userModel.userInfo.e164PhoneNumber)
                }
                Section() {
                    Button("Save Name") {
                        Task {
                            await userModel.saveUsername(username: nameString)
                        }
                    }
                }
                Section() {
                    Button {
                        userModel.logOut()
                    } label: {
                        Text("Log Out")
                            .foregroundStyle(Color.red)
                    }
                }
            }
        }
        .onAppear() {
            nameString = userModel.userInfo.name ?? ""
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserModel())
}
