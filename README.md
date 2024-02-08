#  MyWalletApp Documentation
**Russell Umboh - 918720281**

## Overview
MyWallet is a simple digital wallet application that consists of six primary
screens: 1) a splash screen with a logo and name, 2) a login screen wherein
users can input a phone number and send an OTP to that number, 3) an OTP
verification screen wherein users can enter the OTP received by their phone
number to access the rest of the application, 4) a loading screen that loads
user information upon entering the application as an authenticated user, 5) a
home screen that displays user accounts and total asset value in USD, and 6) a
settings screen that allows users to see and modify their personal information
as well as log out of the application.

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
and current balance of each account. It also displays the total balance of the
user's accounts. The screen also contains a button that allows the user to
create a new account with zero balance in the application. The user can also
navigate to the settings screen from this page.

#### Adding a New Account
Upon clicking on the `+` button on the home screen, the user is taken to a
separate screen with a textfield to enter the name of their new account. By
clicking on the `Create` button on that screen, the user navigates back to the
home screen, where their new account shall be displayed with a balance of zero
dollars.

#### Account Details and Transactions
The user can view more detailed information on each account by tapping on a
specific account entry on the home screen. This takes them to an account details
screen associated with the account they selected. On this page, the account's
name and balance will be displayed once again, along with buttons to perform the
following transactions with the account: `Deposit`, `Withdraw`, and `Transfer`.
A text field is also provided for the user to enter a specified amount of money
to conduct a transaction.

If the user selects `Deposit`, the inputted amount of money will be added to the
balance for that specific account. In the home screen, the total assets value
and account balance will also be increased accordingly.

If the user selects `Withdraw`, the inputted amount of money will be deducted to
the balance for that specific account, if possible. In the home screen, the
total assets value and the account balance will also be decreased accordingly.

If the user selects `Transfer`, a seperate view will be brought up in the screen
prompting the user to select an account to transfer the inputted amount from
their currently viewed account. Once the user makes their selection and clicks
the `Transfer` button, the money is deducted from their current account and
added to the selected account accordingly, if possible. In the home screen, the
account balances of the involved accounts will be updated accordingly.

In the case the user makes an invalid transaction (e.g. not inputting an amount
or attempting to withdraw/transfer more than the account balance), an
appropriate error message will be displayed.

Finally, the user can click on the trash can icon on the right of the toolbar in
order to delete the account. This navigates the user back to the home screen and
removes the deleted account from the displayed entries, subtracting the account
balance from the total assets accordingly.

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

#### saveUsername(username: String) async -> void
This async method saves a specified username for the user associated with
`authenticationToken`. This is done via an API call with the Api `setUserName`,
which passes in `authenticationToken` and `username` as parameters. It then sets
`userInfo` to the updated user information returned by the Api function call. If
the API call fails or the authentication code is missing, `errorMessage` is set
appropriately.

#### createAccount(name: String) async -> void
This async method creates a new account with a specified name for the user associated with `authenticationToken`. This is done via an API call with the Api `createAccount`,
which passes in `authenticationToken` and `name` as parameters. It then sets
`userInfo` to the updated user information returned by the Api function call. If
the API call fails or the authentication code is missing, `errorMessage` is set
appropriately.

#### deleteAccount(account: Account) async -> void
This async method deletes the account specified by the `account` parameter for
the user associated with `authenticationToken`. This is done via an API call
with the Api `deleteAccount`, which passes in `authenticationToken` and `name`
as parameters. It then sets `userInfo` to the updated user information returned
by the Api function call. If the API call fails or the authentication code is
missing, `errorMessage` is set appropriately.

#### deposit(account: Account, accountIndex: Int, amount: String) async -> Account
This async method deposits `amount` (converted to an Int to represent the amount
in cents) into the account specified by the `account` parameter for the user
associated with `authenticationToken`.  This is done via an API call with the
Api `deposit`, which passes in `authenticationToken`, `account` and `amount` as
parameters. It then sets `userInfo` to the updated user information returned by
the Api function call. Furthermore, the function returns the updated account
information if the Api call is successful. If the API call fails or the
authentication code is missing, `errorMessage` is set appropriately and the
function returns the original account.

#### withdraw(account: Account, accountIndex: Int, amount: String) async -> Account
This async method withdraws `amount` (converted to an Int to represent the
amount in cents) into the account specified by the `account` parameter for the
user associated with `authenticationToken`.  This is done via an API call with
the Api `deposit`, which passes in `authenticationToken`, `account` and `amount`
as parameters. It then sets `userInfo` to the updated user information returned
by the Api function call. Furthermore, the function returns the updated account
information if the Api call is successful. If the API call fails or the
authentication code is missing, `errorMessage` is set appropriately and the
function returns the original account.

#### transfer(from: Account, to: Account, accountIndex: Int, amount: String) async -> Account
This async method transfers `amount` (converted to an Int to represent the
amount in cents) into the account specified by the `to` parameter from the
`from` parameter for the user associated with `authenticationToken`.  This is
done via an API call with the Api `deposit`, which passes in
`authenticationToken`, `from`, `to` and `amount` as parameters. It then sets
`userInfo` to the updated user information returned by the Api function call.
Furthermore, the function returns the updated account information if the Api
call is successful. If the API call fails or the authentication code is missing,
`errorMessage` is set appropriately and the function returns the original
account.


#### logOut() -> void
This method logs out the user by calling the
`UserDefaults.standard.removeObject(forKey: "authToken")`. This deletes the
key-value pair aßssociated with the `authToken` key from `Userdefaults`. It then
exits the application.