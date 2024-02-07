//
//  HomeView.swift
//  MyWallet
//
//  Created by Russell Umboh on 1/21/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userModel: UserModel
    @State var totalAssetsAmount: String = "$0.00"
    @State var areAccountsLoaded: Bool = false
    @State var navigateToSettings: Bool = false
    @State var navigateToAccount: Bool = false
    var body: some View {
            VStack {
                VStack {
                    Text("Total Assets")
                        .foregroundStyle(Color.white)
                    Text(totalAssetsAmount)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                        .foregroundStyle(Color.white)
                }
                .frame(maxWidth: .infinity, maxHeight: 300)
                .background(Color.blue)
                if areAccountsLoaded {
                    Form {
                        ForEach(userModel.userInfo.accounts) { account in
                            Button {
                                
                            } label: {
                                HStack {
                                    Text(account.name)
                                        .foregroundStyle(Color.primary)
                                    Spacer()
                                    Text(account.balanceString())
                                        .foregroundStyle(Color.primary)
                                    Image(systemName: "chevron.right")
                                        .tint(Color.gray)
                                }
                            }
                        }
                    }
                    .overlay(alignment:.bottomTrailing) {
                        Button {
                            
                        } label: {
                            Text("+")
                                .font(.title)
                                .frame(width:75, height:75)
                                .foregroundStyle(Color.white)
                                .background(Color.blue)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        }
                    }
                    .padding()
                }
                Spacer()
            }
            .task {
                areAccountsLoaded = await userModel.loadAccounts()
                var totalAmount: Double = 0.0
                for account in userModel.userInfo.accounts {
                    totalAmount += account.balanceInUsd()
                }
                totalAssetsAmount = String(format: "$%0.02f", totalAmount)
            }
            .toolbar {
                ToolbarItem(placement: .principal){
                    Text("Wallet")
                        .bold()
                        .foregroundStyle(Color.blue)
                }
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
                    .environmentObject(userModel)
            }
        
    }
}

#Preview {
    HomeView()
        .environmentObject(UserModel())
}
