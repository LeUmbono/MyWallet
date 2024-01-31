//
//  LoadingScreenView.swift
//  MyWallet
//
//  Created by Russell Umboh on 1/30/24.
//

import SwiftUI

struct LoadingScreenView: View {
    @EnvironmentObject var userModel: UserModel
    @State var errorMessage: String = ""
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    LoadingScreenView()
}
