//
//  File.swift
//  
//
//  Created by Арман Чархчян on 30.05.2022.
//

import Foundation
import NetworkServices
import FirebaseAuth

protocol AuthNetworkServiceProtocol: AnyObject {
    func signOut(completion: @escaping (Error?) -> ())
}

final class AuthNetworkService {
    private let authNetworkService: Auth
    
    init(authNetworkService: Auth) {
        self.authNetworkService = authNetworkService
    }
}

extension AuthNetworkService: AuthNetworkServiceProtocol {
    func signOut(completion: @escaping (Error?) -> ()) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            completion((ConnectionError.noInternet))
            return
        }
        try? self.authNetworkService.signOut()
        completion(nil)
    }
}
