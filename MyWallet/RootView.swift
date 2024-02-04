//
//  RootView.swift
//  MyWallet
//
//  Created by Russell Umboh on 1/29/24.
//

import SwiftUI

struct RootView: View {
    @StateObject var userModel = UserModel()
    @State var isAuthenticated: Bool = true
    var body: some View {
        NavigationStack {
            VStack {
                if isAuthenticated {
                    LoadingScreenView()
                        .environmentObject(userModel)
                }
                else {
                    LoginView()
                }
            }
            .task {
                isAuthenticated = userModel.hasAuthentication()
            }
        }
    }
}

#Preview {
    RootView()
}
