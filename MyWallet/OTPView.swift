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
    // Array of strings that correspond to the text in each text field.
    @State var otpDigits: [String] = Array(repeating: "", count: 6)
    // Text of the label to display error message.
    @State var labelText: String = ""
    // Variable that determines whether to show the error label.
    @State var isErrorDetected: Bool = false
    // Variable that determines if the Home view is to be navigated to.
    @State var navigateToHome: Bool = false
    // Tracks the focus state of each text field.
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
                        // Prevent text fields from being clicked/tapped.
                        .allowsHitTesting(false)
                        .onKeyPress(keys:[.delete]) { _ in
                            otpFieldFocus = (otpFieldFocus ?? 0) - 1
                            // Upon deletion, move to the previous text field.
                            if otpDigits[index].isEmpty {
                                if index > 0 {
                                    otpDigits[index-1] = ""
                                }
                            }
                            else {
                                otpDigits[index] = ""
                            }
                            return .handled
                        }
                        .onChange(of: otpDigits[index]) { oldValue, newValue in
                            // Updates text if user types new value into text field with a digit already present.
                            if newValue.count > 1 {
                                otpDigits[index] = String(otpDigits[index].suffix(1))
                            }
                            
                            // Move to the next text field once digit entered.
                            if !newValue.isEmpty {
                                if index == otpDigits.count - 1 {
                                    otpFieldFocus = nil
                                    
                                    otpCode = otpDigits.joined()
                                    
                                    // Verify OTP code once all digits inputted.
                                    Task {
                                        do {
                                            let _ = try await Api.shared.checkVerificationToken(e164PhoneNumber: phoneNumber, code: otpCode)
                                            // If verified successfully, move to Home view automatically.
                                            navigateToHome = true
                                        } catch let apiError as ApiError {
                                            // Show appropriate error message if verification code is incorrect.
                                            isErrorDetected = true
                                            labelText = apiError.message
                                            otpFieldFocus = otpDigits.count - 1
                                        }
                                    }
                                }
                                else {
                                    otpFieldFocus = (otpFieldFocus ?? 0) + 1
                                }
                            }
                        }
                    }
                }
                .onAppear() {
                    // Set focus to the first text field on entry into the view.
                    otpFieldFocus = 0
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
