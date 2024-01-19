#  MyWalletApp Documentation
**Russell Umboh - 918720281**

## Overview
MyWallet is a simple digital wallet application that contains two screens: 1) a
splash screen with a logo and name, and 2) a login screen wherein users can
input a phone number and send an OTP to that number.

## Features
### Splash Screen
The splash screen containing the app's logo and name was implemented through
Storyboard, wherein constraints to center these elements were implemented.

### Login Screen
The login screen presents the user with instructions to input their phone number in the provided text field. The user can then press the "Send OTP" button below the text field to submit their phone number.

#### As You Type Formatting
As the user inputs their phone number, their phone number is automatically
formatted through the `PhoneNumberKit` package's `PartialFormatter`. This was
implemented by utilizing the text field's `onChange` property which can track
changes to the string associated with the text field (`phoneNumberTextField`).
When the text field detects a change to its inputted text, it calls
`PartialFormatter`'s `formatPartial` function with `phoneNumberTextField` as its
argument and sets `phoneNumberTextField`'s value to the output of the function. 

#### Keyboard Behavior
The text field's `keyboardType` property is set to `numberPad`, ensuring the
keyboard only displays number keys when appearing. \
\
When the user taps out of the text field or presses the "Send OTP" button, the
keyboard is hidden (if it is already being displayed). This is done through
making use of a FocusState variable `isPhoneNumberFocused` to keep track of
whether or not the text field is selected through its `focusable` property. \
\
The outermost VStack containing all of the elements in the login screen is given
a `onTapGesture` property that calls the `removeKeyboard` function, which simply
sets `isPhoneNumberFocused` to false, thereby removing the keyboard from the
screen if the user taps out of the text field. In addition, this VStack's
maximum width and height were set to infinity and a background given so as to
cover the entirety of the screen. \
\
The "Send OTP" button also calls the
`removeKeyboard` function when pressed, guaranteeing the same functionality when
clicked.

#### Phone Number Validation and Label
When the user clicks on the "Send OTP" button, input validation is carried out
on the inputted phone number by utilizing `PhoneNumberKit`'s `parse` function.
This function converts a valid phone number into a `PhoneNumber` object,
otherwise it returns an exception indicating that the phone number is invalid. \
\
Furthermore, when the user clicks on the "Send OTP" button, the boolean
`isButtonPressed` (whose default value is `false`) is set to `true`. This tells
the login screen to display a label when the button is pressed. If the phone
number is determined to be valid, the boolean `isPhoneNumberValid` is
additionally set to `true`. Else, it is set to `false`. This state variable
determines whether or not the label that appears contains a validation message
and the phone number in E164 format (in the case of `true`) or an error message
(in the case of `false`). \
\
To convert the phone number in the text field into E164 format, I used
`PhoneNumberKit`'s `format` function, passing in a `PhoneNumber` object to be
formatted with the phone number and type `e164`, storing the resultant number in
the `phoneNumberE164` state variable. \