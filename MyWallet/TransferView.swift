//
//  TransferView.swift
//  MyWallet
//
//  Created by Russell Umboh on 2/7/24.
//

import SwiftUI

struct TransferView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var userModel: UserModel
    @Binding var currentAccount: Account
    @Binding var amountToTransfer: String
    @Binding var errorString: String
    @State var currentAccountIndex: Int
    @State var selectedAccountIndex: Int = 0
    
    var body: some View {
        Form {
            Picker("Transfer To", selection: $selectedAccountIndex)
            {
                ForEach(0..<userModel.userInfo.accounts.count, id: \.self) { index in
                    HStack {
                        Text(userModel.userInfo.accounts[index].name)
                        Spacer()
                        Text(userModel.userInfo.accounts[index].balanceString())
                            .foregroundStyle(Color.gray)
                    }.tag(index)
                }
            }
            .pickerStyle(.inline)
            
            Button
            {
                Task 
                {
                    currentAccount = await userModel.transfer(from: userModel.userInfo.accounts[currentAccountIndex], to: userModel.userInfo.accounts[selectedAccountIndex], accountIndex: currentAccountIndex, amount: amountToTransfer)
                    errorString = userModel.errorMessage
                    dismiss()
                }
            } label: {
                Text("Transfer")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
            .buttonStyle(.borderedProminent)
        }

    }
}

#Preview {
    TransferView(currentAccount: .constant(Account(name: "", id: "", balance: 0)), amountToTransfer: .constant("0.00"), errorString: .constant(""), currentAccountIndex: 0)
        .environmentObject(UserModel())
}
