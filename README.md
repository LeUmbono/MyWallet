#  MyWalletApp Documentation
**Russell Umboh - 918720281**

## Overview
MyWallet is a simple digital wallet application that consists of six screens: 1)
a splash screen with a logo and name, 2) a login screen wherein users can input
a phone number and send an OTP to that number, 3) an OTP verification screen
wherein users can enter the OTP received by their phone number to access the
rest of the application, 4) a loading screen that loads user information upon
entering the application as an authenticated user, 5) a home screen that
displays user accounts and total asset value in USD, and 6) a settings screen
that allows users to see and modify their personal information as well as log
out of the application.

## Features
### Splash Screen
The splash screen containing the app's logo and name was implemented through
Storyboard, wherein constraints to center these elements were implemented. It is
shown briefly when the user first starts up the application.

### Login Screen
If the user does not have an associated authentication code, they are taken to
this screen from the splash screen. The login screen presents the user with
instructions to input their phone number in the provided text field. The user
can then press the "Send OTP" button below the text field to submit their phone
number to which the application sends an OTP code. This also takes the user to
the OTP verification screen.

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
keyboard only displays the appropriate symbols when inputting a phone number. 

When the user taps out of the text field or presses the "Send OTP" button, the
keyboard is hidden (if it is already being displayed). This is done through
making use of a FocusState variable `isPhoneNumberFocused` to keep track of
whether or not the text field is selected through its `focusable` property. 

The outermost VStack containing all of the elements in the login screen is given
a `onTapGesture` property that calls the `removeKeyboard` function, which simply
sets `isPhoneNumberFocused` to false, thereby removing the keyboard from the
screen if the user taps out of the text field. In addition, this VStack's
maximum width and height were set to infinity and a background given so as to
cover the entirety of the screen. 

The "Send OTP" button also calls the `removeKeyboard` function when pressed,
guaranteeing the same functionality when clicked.

#### Phone Number Validation and Label
When the user clicks on the "Send OTP" button, input validation is carried out
on the inputted phone number by utilizing `PhoneNumberKit`'s `parse` function.
This function converts a valid phone number into a `PhoneNumber` object,
otherwise it returns an exception indicating that the phone number is invalid. 

Furthermore, when the user clicks on the "Send OTP" button, the boolean
`isButtonPressed` (whose default value is `false`) is set to `true`. This tells
the login screen to display a label when the button is pressed. If the phone
number is determined to be valid, the label is
set to show this information. Else, an appropriate error message is shown. 

To convert the phone number in the text field into E164 format, I used
`PhoneNumberKit`'s `format` function, passing in a `PhoneNumber` object to be
formatted with the phone number and type `e164`, storing the resultant number in
the `phoneNumberE164` state variable. 

#### Navigation to OTP Verification Screen
Navigation to the OTP verification screen is performed by wrapping the wrapper
VStack view with a NavigationStack and setting a `.navigationDestination` that
redirects to the OTP verification screen when the boolean `navigateToOTPView` is
set to `true` (which is done when the user taps on the Send OTP button). 

### OTP Verification Screen
The OTP verification screen presents the user with instructions to input the OTP
code that has been sent to their designated phone number. Upon inputting all six
digits (either via the keyboard or through autofill), the OTP code entered is
validated. If the OTP code is a valid match, the user is automatically taken to
the application's home screen. In doing so, the user associates themselves with
an authentication code via UserDefault, marking them as an authenticated user
when they open the application next. Their user data is also loaded before
transitioning into the home screen. If the OTP code is invalid, an appropriate
error message will be shown and the OTP entry field is emptied out, allowing the
user to re-enter their code. The user also has the option of clicking a button
on the screen to resend their OTP code to their designated phone number.

#### OTP Entry 
The entry region for the OTP is defined by a ZStack consisting of a hidden text
field (bound to `otpCode` and opacity set to 0) and an HStack containing six
separate text views, each displaying one character from the string `otpCode`.
The text field's `.keyboardType` property is set to `.phonePad`, ensuring the
keyboard displays the appropriate symbols when inputting the OTP code. To
prevent direct interaction with the text field, the `.allowsHitTesting` property
was also added with a value of `false` whenever not in focus, preventing users
from tapping on the text field to interact with it and potentially changing
other digits aside from the digit they're currently typing.

Upon entering the OTP verification screen, `otpField` is automatically set to
true via the `.onAppear` property of the text field, bringing up the keyboard for
entry. Inputting a digit immediately moves the focus to the next text view.
Similarly, deleting a digit immediately moves the focus to the previous text
view.

### Loading Screen
If the user has an associated authentication code, the splash screen takes the
user to this screen instead of the login screen. While the screen is being
shown, the application attempts to loads the user data associated with the
authentication code. If it succeeds in loading the data, the user is taken to
the home screen. Otherwise, an appropriate error message is displayed in the
loading screen. 

### Home Screen
The home screen displays the accounts associated with a user, showing the name,
id and current balance of each account. It also displays the total balance of
the user's accounts. In case no accounts are associated with the user or the
accounts fail to be loaded, a `No Accounts Created` message is displayed. The
user can also navigate to the settings screen from this page.

### Settings Screen
The setting screen displays the information associated with a user, which
includes their name and phone number. The username of the user is editable, and
is saved into the database by clicking the `Save Name` button. The user is also
able to log out of the application by clicking the `Log Out` button. This erases
the authentication code associated with the user in UserDefaults and
additionally exits the application. 

### UserModel Class
The `UserModel` class is used to persistently keep track of user information
throughout the application. It contains the following properties: the String
`authenticationToken` which holds the authentication token associated with the
user, the User `userInfo` which holds information regarding the user's name, id,
phone number and accounts, the String `errorMessage` which holds the latest
error information in case certain class methods or API calls fail to execute as
intended.

The `UserModel` class also contains a number of methods intended to facilitate
the storage and manipulation of user data, which are normally called via .task
property or a defined Task protocol in a View. 

#### storeAuthentication(authToken: String) -> void
This method is called when an authenticated user successfully inputs an OTP code
in the OTP verification screen. It sets the `authenticationToken` to the user's
newly generated token and saves it via `UserDefaults` under the key `authToken`.

#### hasAuthentication() -> Bool
This method retrieves the authentication token stored in `UserDefaults`. If the
authentication token is successfully retrieved, the function returns `true`.
Otherwise, it returns `false`.

#### loadUser() async -> Bool
This async method loads user data associated with `authenticationToken` and stores it
in `userInfo`. This is done through an API call with the Api `user` function,
which passes in `authenticationToken` as a parameter. If loaded successfully,
the function returns `true`. If the API call fails or the authentication code is
missing, `errorMessage` is set appropriately. The function also returns `false`.

#### loadAccounts() async -> Bool
This async method checks if the number of accounts associated with the user is
greater than zero. If so, it returns `true`. Else, it returns `false`.

#### saveUsername(username: String) async -> void
This async method saves a specified username for the user associated with
`authenticationToken`. This is done via an API call with the Api `setUserName`,
which passes in `authenticationToken` and `username` as parameters. It then sets
`userInfo` to the updated user information returned by the Api function call. If
the API call fails or the authentication code is missing, `errorMessage` is set
appropriately.

#### logOut() -> void
This method logs out the user by calling the
`UserDefaults.standard.removeObject(forKey: "authToken")`. This deletes the
key-value pair aßssociated with the `authToken` key from `Userdefaults`. It then
exits the application.