//
//  UserModel.swift
//  MyWallet
//
//  Created by Russell Umboh on 1/28/24.
//

import Foundation

class UserModel : ObservableObject {
    @Published var authenticationToken: String?
    @Published var userInfo: User
    @Published var errorMessage: String
    
    let missingAuthToken = ApiError(errorCode: "missing_auth_token_error", message: "Auth token is not set")
    
    init(authenticationToken: String? = nil, userInfo: User = User(e164PhoneNumber: "", name: nil, userId: "", accounts: []), errorMessage: String = "") {
        self.authenticationToken = authenticationToken
        self.userInfo = userInfo
        self.errorMessage = errorMessage
    }
    
    // Sets authentication token and store it via User Defaults.
    @MainActor
    func storeAuthentication(authToken: String)  {
        authenticationToken = authToken
        UserDefaults.standard.setValue(authToken, forKey: "authToken")
        UserDefaults.standard.synchronize()
    }
    
    // Checks if authentication token exists for a user and reads it into the user model.
    @MainActor
    func hasAuthentication() -> Bool {
        if let authToken = UserDefaults.standard.string(forKey: "authToken") {
            authenticationToken = authToken
            return true
        }
        else {
            return false
        }
    }
    
    // Loads user information into the user model.
    @MainActor
    func loadUser() async -> Bool
    {
        clearErrorMessage()
        // Check if authentication token is null.
        if let authToken = authenticationToken {
            // Loads user if Api call succeeds.
            do {
                let userResponse = try await Api.shared.user(authToken: authToken)
                self.userInfo = userResponse.user
                return true
            } catch let apiError as ApiError {
                self.errorMessage = apiError.message
                return false
            } catch {
                self.errorMessage = "Unknown error."
                return false
            }
        }
        else {
            self.errorMessage = self.missingAuthToken.message
            return false
        }
    }
    
    // Saves inputted username into user model.
    @MainActor
    func saveUsername(username: String) async {
        clearErrorMessage()
        if let authToken = authenticationToken {
            do {
                let userResponse = try await Api.shared.setUserName(authToken: authToken, name: username)
                self.userInfo = userResponse.user
            } catch let apiError as ApiError {
                self.errorMessage = apiError.message
            } catch {
                self.errorMessage = "Unknown error."
            }
        }
        else {
            self.errorMessage = self.missingAuthToken.message
        }
    }
    
    @MainActor
    func createAccount(name: String) async {
        clearErrorMessage()
        if let authToken = authenticationToken {
            do {
                let userResponse = try await Api.shared.createAccount(authToken: authToken, name: name)
                self.userInfo = userResponse.user
            } catch let apiError as ApiError {
                self.errorMessage = apiError.message
            } catch {
                self.errorMessage = "Unknown error."
            }
        }
        else {
            self.errorMessage = self.missingAuthToken.message
        }
    }
    
    @MainActor
    func deleteAccount(account: Account) async
    {
        clearErrorMessage()
        if let authToken = authenticationToken {
            do {
                let userResponse = try await Api.shared.deleteAccount(authToken: authToken, account: account)
                self.userInfo = userResponse.user
            } catch let apiError as ApiError {
                self.errorMessage = apiError.message
            } catch {
                self.errorMessage = "Unknown error."
            }
        }
        else {
            self.errorMessage = self.missingAuthToken.message
        }
    }
    
    @MainActor
    func deposit(account: Account, accountIndex: Int, amount: String) async -> Account
    {
        clearErrorMessage()
        let amountInCents: Double = (Double(amount) ?? 0) * 100
        if let authToken = authenticationToken {
            do {
                let userResponse = try await Api.shared.deposit(authToken: authToken, account: account, amountInCents: Int(amountInCents))
                self.userInfo = userResponse.user
                return userResponse.user.accounts[accountIndex]
            } catch let apiError as ApiError {
                self.errorMessage = apiError.message
            } catch {
                self.errorMessage = "Unknown error."
            }
        }
        else {
            self.errorMessage = self.missingAuthToken.message
        }
        
        return account
    }
    
    @MainActor
    func withdraw(account: Account, accountIndex: Int, amount: String) async -> Account
    {
        clearErrorMessage()
        let amountInCents: Double = (Double(amount) ?? 0) * 100
        if let authToken = authenticationToken {
            do {
                let userResponse = try await Api.shared.withdraw(authToken: authToken, account: account, amountInCents: Int(amountInCents))
                self.userInfo = userResponse.user
                return userResponse.user.accounts[accountIndex]
            } catch let apiError as ApiError {
                self.errorMessage = apiError.message
            } catch {
                self.errorMessage = "Unknown error."
            }
        }
        else {
            self.errorMessage = self.missingAuthToken.message
        }
        
        return account
    }
    
    @MainActor
    func transfer(from: Account, to: Account, accountIndex: Int, amount: String) async -> Account
    {
        clearErrorMessage()
        let amountInCents: Double = (Double(amount) ?? 0) * 100
        if let authToken = authenticationToken {
            do {
                let userResponse = try await Api.shared.transfer(authToken: authToken, from: from, to: to, amountInCents: Int(amountInCents))
                self.userInfo = userResponse.user
                return userResponse.user.accounts[accountIndex]
            } catch let apiError as ApiError {
                self.errorMessage = apiError.message
            } catch {
                self.errorMessage = "Unknown error."
            }
        }
        else {
            self.errorMessage = self.missingAuthToken.message
        }
        
        return from
    }
    
    // Logs user out of application.
    func logOut() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.synchronize()
        exit(0)
    }
    
    func clearErrorMessage() {
        errorMessage = ""
    }
}

