//
//  UserModel.swift
//  MyWallet
//
//  Created by Russell Umboh on 1/28/24.
//

import Foundation

class UserModel : ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var authenticationToken: String? = nil
    @Published var userInfo: User? = nil
    @Published var apiError: ApiError? = nil
    
  
    func user(authToken: String) async -> User
    {
        do {
            let userResponse = try await Api.shared.user(authToken: authToken)
            userInfo = userResponse.user
        } catch let apiError as ApiError {
            
        }
    }
   
}

