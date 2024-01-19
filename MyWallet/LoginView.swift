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
    // State variable to show error/valid label upon validating number.
    @State var isValidPhoneNumber: Bool = false
    // State variable that tracks if OTP button has been clicked.
    @State var isButtonPressed: Bool = false
    // Tracks focus state of phone number text field.
    @FocusState var isPhoneNumberFocused: Bool
    
    let phoneNumberKit = PhoneNumberKit()
    
    // Remove keyboard from screen by setting focus state to false.
    func removeKeyboard()
    {
        isPhoneNumberFocused = false
    }
    
    var body: some View {
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
                .keyboardType(.numberPad)
            }
            Button(action: {
                do {
                    // Button has been pressed.
                    isButtonPressed = true
                    let phoneNumber = try phoneNumberKit.parse(phoneNumberTextField)
                    // If exception not thrown, phone number is valid.
                    isValidPhoneNumber = true
                    // Store phone number in text field in E164 format.
                    phoneNumberE164 = phoneNumberKit.format(phoneNumber, toType: .e164)
                }
                catch {
                    isValidPhoneNumber = false
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
                if isValidPhoneNumber
                {
                    VStack{
                        Text(phoneNumberE164)
                        Text("The OTP has been sent to your phone number")
                            .foregroundStyle(Color.green)
                    }
                }
                else
                {
                    Text("The phone number is invalid or does not exist.")
                        .foregroundStyle(Color.red)
                }
            }
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity, 
               alignment: .leading)
        .background(Color.white)
        .onTapGesture {
            // Dismisses keyboard when user taps outside.
            removeKeyboard()
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
