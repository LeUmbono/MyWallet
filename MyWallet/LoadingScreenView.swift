//
//  LoadingScreenView.swift
//  MyWallet
//
//  Created by Russell Umboh on 1/30/24.
//

import SwiftUI

struct LoadingScreenView: View {
    @EnvironmentObject var userModel: UserModel
    @State var errorString: String = ""
    @State var navigateToHome: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                ProgressView()
                    .padding()
                Text(errorString)
                    .foregroundStyle(Color.red)
            }
            .padding()
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
                    .environmentObject(userModel)
            }
            .task {
                navigateToHome = await userModel.loadUser()
                errorString = userModel.errorMessage
            }
        }
    }
}

#Preview {
    LoadingScreenView()
        .environmentObject(UserModel())
}
