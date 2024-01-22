//
//  OTPView.swift
//  MyWallet
//
//  Created by Russell Umboh on 1/21/24.
//

import SwiftUI

struct OTPView: View {
    @State var otpCode: String = ""
    @State var otpDigits: [String] = Array(repeating: "", count: 6)
    @State var showHome: Bool = false
    @FocusState var otpFieldFocus: Int?
    var body: some View {
        NavigationStack {
            VStack {
                Text("What's the code?")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity)
                Text("Enter the code sent to")
                    .frame(maxWidth: .infinity)
                    .padding(.bottom)
                HStack {
                    ForEach(otpDigits.indices, id: \.self) { index in
                        TextField("",
                                  text: $otpDigits[index]
                        )
                        .frame(width: 48, height: 48)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                        .keyboardType(.phonePad)
                        .multilineTextAlignment(.center)
                        .focused($otpFieldFocus, equals: index)
                        .tag(index)
                        .allowsHitTesting(false)
                        .onAppear() {
                            otpFieldFocus = 0
                        }
                        .onKeyPress(keys:[.delete]) { _ in
                            if(otpDigits[index].isEmpty) {
                                otpFieldFocus = (otpFieldFocus ?? 0) - 1
                            }
                            otpDigits[index] = ""
                            return .handled
                        }
                        .onChange(of: otpDigits[index]) { oldValue, newValue in
                            if newValue.count > 1 {
                                let currentValue = Array(otpDigits[index])
                                if currentValue[0] == Character(oldValue) {
                                    otpDigits[index] = String(otpDigits[index].suffix(1))
                                }
                                else {
                                    otpDigits[index] = String(otpDigits[index].prefix(1))
                                }
                            }
                            if !newValue.isEmpty {
                                if index == otpDigits.count - 1 {
                                    otpFieldFocus = nil
                                    showHome = true
                                }
                                else {
                                    otpFieldFocus = (otpFieldFocus ?? 0) + 1
                                }
                            }
                            else {
                                otpFieldFocus = (otpFieldFocus ?? 0) - 1
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
            .background(Color.white)
            .padding()
            .navigationDestination(isPresented: $showHome) {
                HomeView()
            }
        }
    }
}

#Preview {
    OTPView()
}
