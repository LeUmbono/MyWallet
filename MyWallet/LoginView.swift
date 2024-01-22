//
//  ContentView.swift
//  MyWallet
//
//  Created by Russell Umboh on 1/12/24.
//

import SwiftUI
import PhoneNumberKit

struct LoginView: View {
    // State variable to store value of phone number for text field.
    @State var phoneNumberTextField: String = ""
    // State variable to store E164 value of phone number for processing.
    @State var phoneNumberE164: String = ""
    // State variable to store text for label.
    @State var labelText: String = ""
    // State variable to store text color for label
    @State var labelColor: Color = .black
    // State variable that tracks if OTP button has been clicked.
    @State var isButtonPressed: Bool = false
    // State variable that determines if OTP view is to be shown.
    @State var navigateToOTPView: Bool = false
    // Tracks focus state of phone number text field.
    @FocusState var isPhoneNumberFocused: Bool
    
    let phoneNumberKit = PhoneNumberKit()
    
    // Remove keyboard from screen by setting focus state to false.
    func removeKeyboard()
    {
        isPhoneNumberFocused = false
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Enter your phone number")
                    .font(.title2)
                    .bold()
                HStack{
                    Text("+1")
                    TextField(PartialFormatter().formatPartial("5309533880"),
                              text: $phoneNumberTextField
                    )
                    .focused($isPhoneNumberFocused)
                    .onChange(of: phoneNumberTextField){
                        phoneNumberTextField = PartialFormatter().formatPartial(phoneNumberTextField)
                    }
                    .keyboardType(.phonePad)
                }
                Button(action: {
                    do {
                        // Button has been pressed.
                        isButtonPressed = true
                        let phoneNumber = try phoneNumberKit.parse(phoneNumberTextField)
                        
                        // Store phone number in text field in E164 format.
                        phoneNumberE164 = phoneNumberKit.format(phoneNumber, toType: .e164)
                        
                        // Send OTP to valid phone number.
                        Task {
                            do {
                                let _ = try await Api.shared.sendVerificationToken(e164PhoneNumber: phoneNumberE164)
                                navigateToOTPView = true
                            } catch let apiError as ApiError {
                                // Show appropriate error message if verification code not received.
                                labelText = apiError.message
                                labelColor = Color.red
                            }
                        }
                        
                        labelText = "The OTP has been sent to your phone number."
                        labelColor = Color.green
                    }
                    catch {
                        labelText = "The phone number is invalid or does not exist."
                        labelColor = Color.red
                    }
                    
                    // Dismisses keyboard when user taps the button.
                    removeKeyboard()
                }, label: {
                    Text("Send OTP")
                        .bold()
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                })
                .buttonStyle(.borderedProminent)
                
                if isButtonPressed {
                    Text(labelText)
                        .foregroundStyle(labelColor)
                }
                
            }
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
            .background(Color.white)
            .onTapGesture {
                // Dismisses keyboard when user taps outside.
                removeKeyboard()
            }
            .padding()
            .navigationDestination(isPresented: $navigateToOTPView) {
                OTPView(phoneNumber: $phoneNumberE164)
            }
        }
    }
}

#Preview {
    LoginView()
}
