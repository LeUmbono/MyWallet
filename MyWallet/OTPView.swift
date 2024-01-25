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
    // Tracks the tapping functionality of each text field
    @State var areTappable: [Bool] = Array(repeating: false, count: 6)
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
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 5.0))
                        }
                    }
                    TextField("", text: $otpCode)
                        .keyboardType(.phonePad)
                        .textContentType(.oneTimeCode)
                        .focused($otpFieldFocus)
                        .allowsHitTesting(false)
                        .onAppear() {
                            // Set focus of text field to true when user enters the screen.
                            otpFieldFocus = true
                        }
                        .onChange(of: otpCode) { oldValue, newValue in
                            if otpCode.count == 6
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
                        .opacity(0)
                }
                /*
                HStack {
                    ForEach(otpDigits.indices, id: \.self) { index in
                        TextField("",
                                  text: $otpDigits[index]
                        )
                        .frame(width: 48, height: 48)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                        .keyboardType(.phonePad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                        .focused($otpFieldFocus, equals: index)
                        .tag(index)
                        // Prevent text fields from being clicked/tapped.
                        .allowsHitTesting(areTappable[index])
                        .onAppear() {
                            // Set focus to the first text field on entry into the view.
                            otpFieldFocus = 0
                            // Lets first text field be tappable on entry
                            areTappable[0] = true
                        }
                        .onKeyPress(keys:[.delete]) { _ in
                            otpFieldFocus = (otpFieldFocus ?? 0) - 1
                            
                            // Enable and disable appropriate text fields.
                            if index > 0 {
                                areTappable[index] = false
                                areTappable[index-1] = true
                            }
                            
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
                                let currentValue = Array(otpDigits[index])
                                
                                if currentValue[0] == Character(oldValue)
                                {
                                    otpDigits[index] = String(otpDigits[index].suffix(1))
                                }
                                else {
                                    otpDigits[index] = String(otpDigits[index].prefix(1))
                                }
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
                                    
                                    // Enable and disable appropriate text fields.
                                    areTappable[index] = false
                                    areTappable[index+1] = true
                                }
                            }
                        }
                    }
                }
                 */
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
