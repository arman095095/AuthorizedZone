//
//  AccountService.swift
//  
//
//  Created by Арман Чархчян on 10.04.2022.
//

import Foundation
import FirebaseFirestore
import ModelInterfaces
import UIKit
import NetworkServices

protocol AccountNetworkServiceProtocol {
    func setOnline(accountID: String)
    func setOffline(accountID: String)
    func recoverAccount(accountID: String,
                        completion: @escaping (Result<Void, Error>) -> Void)
    
}

final class AccountNetworkService {
    
    private let networkServiceRef: Firestore

    private var usersRef: CollectionReference {
        return networkServiceRef.collection(URLComponents.Paths.users.rawValue)
    }
    
    init(networkService: Firestore) {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        networkService.settings = settings
        self.networkServiceRef = networkService
    }
}

extension AccountNetworkService: AccountNetworkServiceProtocol {
    
    public func setOnline(accountID: String) {
        usersRef.document(accountID).updateData([ProfileURLComponents.Parameters.online.rawValue: true])
    }
    
    public func setOffline(accountID: String) {
        var dict: [String: Any] = [ProfileURLComponents.Parameters.lastActivity.rawValue: FieldValue.serverTimestamp()]
        dict[ProfileURLComponents.Parameters.online.rawValue] = false
        usersRef.document(accountID).updateData(dict) { _ in }
    }
    
    public func recoverAccount(accountID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            completion(.failure(ConnectionError.noInternet))
            return
        }
        usersRef.document(accountID).updateData([ProfileURLComponents.Parameters.removed.rawValue: false], completion: { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        })
    }
}
