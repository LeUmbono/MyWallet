#  MyWalletApp Documentation
**Russell Umboh - 918720281**

## Overview
MyWallet is a simple digital wallet application that consists of four screens: 1) a
splash screen with a logo and name, 2) a login screen wherein users can input a
phone number and send an OTP to that number, 3) an OTP verification screen
wherein users can enter the OTP received by their phone number to access the
rest of the application, and 4) a Home screen that is currently empty.

## Features
### Splash Screen
The splash screen containing the app's logo and name was implemented through
Storyboard, wherein constraints to center these elements were implemented. It is
shown briefly when the user first starts up the application.

### Login Screen
The login screen presents the user with instructions to input their phone number
in the provided text field. The user can then press the "Send OTP" button below
the text field to submit their phone number to which the application sends an
OTP code. This also takes the user to the OTP verification screen.

#### As You Type Formatting
As the user inputs their phone number, their phone number is automatically
formatted through the `PhoneNumberKit` package's `PartialFormatter`. This was
implemented by utilizing the text field's `onChange` property which can track
changes to the string associated with the text field (`phoneNumberTextField`).
When the text field detects a change to its inputted text, it calls
`PartialFormatter`'s `formatPartial` function with `phoneNumberTextField` as its
argument and sets `phoneNumberTextField`'s value to the output of the function. 

#### Keyboard Behavior
The text field's `keyboardType` property is set to `phonePad`, ensuring the
keyboard only displays the appropriate symbols when inputting a phone number. \
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
The "Send OTP" button also calls the `removeKeyboard` function when pressed,
guaranteeing the same functionality when clicked.

#### Phone Number Validation and Label
When the user clicks on the "Send OTP" button, input validation is carried out
on the inputted phone number by utilizing `PhoneNumberKit`'s `parse` function.
This function converts a valid phone number into a `PhoneNumber` object,
otherwise it returns an exception indicating that the phone number is invalid. \
\
Furthermore, when the user clicks on the "Send OTP" button, the boolean
`isButtonPressed` (whose default value is `false`) is set to `true`. This tells
the login screen to display a label when the button is pressed. If the phone
number is determined to be valid, the label is
set to show this information. Else, an appropriate error message is shown. \
\
To convert the phone number in the text field into E164 format, I used
`PhoneNumberKit`'s `format` function, passing in a `PhoneNumber` object to be
formatted with the phone number and type `e164`, storing the resultant number in
the `phoneNumberE164` state variable. \

#### Navigation to OTP Verification Screen
Navigation to the OTP verification screen is performed by wrapping the wrapper
VStack view with a NavigationStack and setting a `.navigationDestination` that
redirects to the OTP verification screen when the boolean `navigateToOTPView` is
set to `true`(which is done when the user taps on the Send OTP button). 

### OTP Verification Screen
The OTP verification screen presents the user with instructions to input the OTP
code that has been sent to their designated phone number. Upon inputting all six
digits, the OTP code entered is validated. If the OTP code is a valid match, the
user is automatically taken to the application's home screen. Otherwise, an
appropriate error message will be shown. The user also has the option of
clicking a button on the screen to resend their OTP code to their designated
phone number.

#### OTP Entry 
The entry region for the OTP is defined by an HStack consisting of six separate text fields, each bound to the elements in the string array `otpDigits`. These text fields' `.keyboardType` property is set to `.phonePad`, ensuring the
keyboard displays the appropriate symbols when inputting an OTP digit. In addition, the FocusState variable `otpField` determines the text field to focus on, corresponding to the index of the elements in the `otpDigits` array. To prevent direct interaction with the text fields, the `.allowsHitTesting` property was also added to each text field with a value of `false`, preventing users from tapping on a text field to input a digit.

Upon entering the OTP verification screen, `otpField` is automatically set to 0 (corresponding to the leftmost text field) via the `.onAppear` property of the HStack. Inputting a digit immediately moves the focus to the next text field by incrementing `otpField` (if applicable). Similarly, deleting a digit immediately moves the focus to the previous text field by decrementing `otpField`, and works even when the user is in the middle of typing something. This was done by defining custom behavior for the Delete key in the `.onKeyPress` property.


### Home Screen
The home screen is currently empty and will be implemented in subsequent
versions of the application.

