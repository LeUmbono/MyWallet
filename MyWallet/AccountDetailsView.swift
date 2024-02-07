//
//  AccountDetailsView.swift
//  MyWallet
//
//  Created by Russell Umboh on 2/6/24.
//

import SwiftUI

struct AccountDetailsView: View {
    @EnvironmentObject var userModel: UserModel
    @Binding var account: Account
    @State var amountString: String = ""
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
                        await userModel.deposit(account: account, amount: amountString)
                    }
                } label: {
                    Text("Deposit")
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                Button {
                    
                } label: {
                    Text("Withdraw")
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                Button {
                    
                } label: {
                    Text("Transfer")
                        .bold()
                }
                .buttonStyle(.borderedProminent)
            }
            
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .principal){
                Text("Account Details")
                    .bold()
            }
            ToolbarItem(placement: .topBarTrailing){
                Button("Delete Account", systemImage: "trash") {
                    
                }
            }
        }
    }
}

#Preview {
    AccountDetailsView(account: .constant(Account(name: "", id: "", balance: 0)))
        .environmentObject(UserModel())
}
