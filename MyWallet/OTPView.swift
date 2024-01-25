//
//  OTPView.swift
//  MyWallet
//
//  Created by Russell Umboh on 1/21/24.
//

import SwiftUI

struct OTPView: View {
    // Binding that takes in the phone number (in E164 format) stored in LoginView.
    @Binding var phoneNumber : String
    // Variable that contains the full OTP code.
    @State var otpCode: String = ""
    // Text of the label to display error message.
    @State var labelText: String = ""
    // Variable that determines whether to show the error label.
    @State var isErrorDetected: Bool = false
    // Variable that determines if the Home view is to be navigated to.
    @State var navigateToHome: Bool = false
    // Tracks the focus state of the hidden text field.
    @FocusState var otpFieldFocus: Bool
    
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
                ZStack {
                    HStack {
                        ForEach(0..<6) { index in
                            // If otpCode has enough characters, display the character int the corresponding text view.
                            Text(otpCode.count >= index + 1 ? String(Array(otpCode)[index]): "")
                                .frame(width: 48, height:48)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 5.0))
                        }
                    }
                    TextField("", text: $otpCode)
                        .opacity(0)
                        .keyboardType(.phonePad)
                        .textContentType(.oneTimeCode)
                        .focused($otpFieldFocus)
                        .allowsHitTesting(false)
                        .onAppear() {
                            // Set focus of text field to true when user enters the screen.
                            otpFieldFocus = true
                        }
                        .onChange(of: otpCode) { oldValue, newValue in
                            if otpCode.count >= 6
                            {
                                otpFieldFocus = false
                                Task {
                                    do {
                                        let _ = try await Api.shared.checkVerificationToken(e164PhoneNumber: phoneNumber, code: otpCode)
                                        // If verified successfully, move to Home view automatically.
                                        navigateToHome = true
                                    } catch let apiError as ApiError {
                                        // Show appropriate error message if verification code is incorrect.
                                        isErrorDetected = true
                                        labelText = apiError.message
                                        
                                        // Reset OTP text field
                                        otpCode = ""
                                        otpFieldFocus = true
                                    }
                                }
                            }
                        }
                }
                // Button to resend OTP code.
                Button(action: {
                    // Send verification token.
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
                
                // Display appropriate error message upon error detected.
                if isErrorDetected {
                    Text(labelText)
                        .foregroundStyle(Color.red)
                }
            }
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
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
