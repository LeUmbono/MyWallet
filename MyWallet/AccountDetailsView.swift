//
//  AccountDetailsView.swift
//  MyWallet
//
//  Created by Russell Umboh on 2/6/24.
//

import SwiftUI

struct AccountDetailsView: View {
    @EnvironmentObject var userModel: UserModel
    @State var account: Account
    @State var accountIndex: Int
    @State var amountString: String = ""
    @State var errorString: String = ""
    @State var isShowingTransactionView: Bool = false
    @State var navigateToHome: Bool = false
    var body: some View {
        VStack {
            Text(account.name)
                .font(.title)
                .bold()
            Text(account.balanceString())
                .font(.title)
            TextField("Amount", text: $amountString)
                .keyboardType(.decimalPad)
            HStack {
                Button {
                    Task {
                        account = await userModel.deposit(account: account, accountIndex: accountIndex, amount: amountString)
                        errorString = userModel.errorMessage
                    }
                } label: {
                    Text("Deposit")
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                Button {
                    Task {
                        account = await userModel.withdraw(account: account, accountIndex: accountIndex, amount: amountString)
                        errorString = userModel.errorMessage
                    }
                } label: {
                    Text("Withdraw")
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                Button {
                    isShowingTransactionView = true
                } label: {
                    Text("Transfer")
                        .bold()
                }
                .buttonStyle(.borderedProminent)
            }
            Text(errorString)
                .foregroundStyle(Color.red)
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .principal){
                Text("Account Details")
                    .bold()
            }
            ToolbarItem(placement: .topBarTrailing){
                Button("Delete Account", systemImage: "trash") {
                    Task {
                        await userModel.deleteAccount(account: account)
                        errorString = userModel.errorMessage
                        navigateToHome = errorString.isEmpty ? true : false
                    }
                }
            }
        }
        .navigationDestination(isPresented: $navigateToHome)
        {
            HomeView()
                .environmentObject(userModel)
        }
        .sheet(isPresented: $isShowingTransactionView) {
            TransferView(currentAccount: $account, amountToTransfer: $amountString, errorString: $errorString, currentAccountIndex: accountIndex)
                .environmentObject(userModel)
        }
    }
}

#Preview {
    AccountDetailsView(account: Account(name: "", id: "", balance: 0), accountIndex: 0)
        .environmentObject(UserModel())
}
