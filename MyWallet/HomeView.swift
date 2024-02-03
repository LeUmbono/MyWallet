//
//  HomeView.swift
//  MyWallet
//
//  Created by Russell Umboh on 1/21/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userModel: UserModel
    @State var areAccountsLoaded: Bool = false
    @State var navigateToSettings: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Text("Total Assets")
                        .foregroundStyle(Color.white)
                    Text("$0.00")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                        .foregroundStyle(Color.white)
                }
                .frame(maxWidth: .infinity, maxHeight: 300)
                .background(Color.blue)
                VStack {
                    Text(areAccountsLoaded ? "$$$" : "No Accounts Created")
                }
                .padding()
                if areAccountsLoaded {
                    ForEach(userModel.userInfo.accounts) { account in
                        VStack {
                            Text("Name: " + account.name)
                                .frame(maxWidth:.infinity, alignment:.leading)
                            Text("ID: " + account.id)
                                .frame(maxWidth:.infinity, alignment:.leading)
                            Text("Balance: " + account.balanceString())
                                .frame(maxWidth:.infinity, alignment:.leading)
                        }
                        .padding()
                    }
                }
                Spacer()
            }
            .task {
                areAccountsLoaded = await userModel.loadAccounts()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    Button("Settings", systemImage: "gear") {
                        navigateToSettings = true
                    }
                }
            }
            .toolbarBackground(Color.white)
            .toolbarBackground(.visible)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigateToSettings) {
                SettingsView()
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(UserModel())
}
