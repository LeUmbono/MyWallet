//
//  OTPView.swift
//  MyWallet
//
//  Created by Russell Umboh on 1/21/24.
//

import SwiftUI

struct OTPView: View {
    @Binding var phoneNumber : String
    @State var otpCode: String = ""
    @State var otpDigits: [String] = Array(repeating: "", count: 6)
    @State var labelText: String = ""
    @State var isErrorDetected: Bool = false
    @State var navigateToHome: Bool = false
    @FocusState var otpFieldFocus: Int?
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("What's the code?")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity)
                Text("Enter the code sent to **\(phoneNumber)**")
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
                                    
                                    otpCode = otpDigits.joined()
                                    
                                    Task {
                                        do {
                                            let _ = try await Api.shared.checkVerificationToken(e164PhoneNumber: phoneNumber, code: otpCode)
                                            navigateToHome = true
                                        } catch let apiError as ApiError {
                                            // Show appropriate error message if verification code not received.
                                            isErrorDetected = true
                                            labelText = apiError.message
                                        }
                                    }
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
                
                // Button to resend OTP code.
                Button(action: {
                    Task {
                        do {
                            let _ = try await Api.shared.sendVerificationToken(e164PhoneNumber: phoneNumber)
                        } catch let apiError as ApiError {
                            // Show appropriate error message if verification code not received.
                            labelText = apiError.message
                        }
                    }
                }, label: {
                    Text("Resend OTP")
                        .bold()
                        .foregroundStyle(Color.white)
                        .padding()
                })
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding()
                
                if isErrorDetected {
                    Text(labelText)
                        .foregroundStyle(Color.red)
                }
            }
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
            .background(Color.white)
            .padding()
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
            }
        }
    }
}

#Preview {
    OTPView(phoneNumber: .constant("+15309533880"))
}
