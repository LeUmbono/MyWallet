//
//  RootView.swift
//  MyWallet
//
//  Created by Russell Umboh on 1/29/24.
//

import SwiftUI

struct RootView: View {
    @StateObject var userModel = UserModel()
    @State var isNewUser: Bool = true
    var body: some View {
        VStack {
            if isNewUser {
                LoginView()
            }
            else {
                LoadingScreenView()
            }
        }
        .onAppear() {
            if UserDefaults.standard.string(forKey: "authToken") != nil {
                isNewUser = false
                print("Hello")
            }
            else {
                isNewUser = true
                print("No!")
            }
        }
    }
}

#Preview {
    RootView()
}
