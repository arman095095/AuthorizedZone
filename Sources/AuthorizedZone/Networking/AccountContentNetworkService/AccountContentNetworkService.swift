//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation
import FirebaseFirestore

protocol AccountContentNetworkServiceProtocol {
    func friendIDs(userID: String, completion: @escaping (Result<[String], Error>) -> ())
    func waitingIDs(userID: String, completion: @escaping (Result<[String], Error>) -> ())
    func requestIDs(userID: String, completion: @escaping (Result<[String], Error>) -> ())
    func getBlockedIds(userID: String, completion: @escaping (Result<[String],Error>) -> Void)
}

final class AccountContentNetworkService {
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

extension AccountContentNetworkService: AccountContentNetworkServiceProtocol {
    
    public func friendIDs(userID: String, completion: @escaping (Result<[String], Error>) -> ()) {
        usersRef.document(userID).collection(URLComponents.Paths.friendIDs.rawValue).getDocuments { query, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let query = query else { return }
            completion(.success(query.documents.map { $0.documentID }))
        }
    }
    
    public func waitingIDs(userID: String, completion: @escaping (Result<[String], Error>) -> ()) {
        usersRef.document(userID).collection(URLComponents.Paths.waitingUsers.rawValue).getDocuments { query, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let query = query else { return }
            completion(.success(query.documents.map { $0.documentID }))
        }
    }
    
    public func requestIDs(userID: String, completion: @escaping (Result<[String], Error>) -> ()) {
        usersRef.document(userID).collection(URLComponents.Paths.sendedRequests.rawValue).getDocuments { query, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let query = query else { return }
            completion(.success(query.documents.map { $0.documentID }))
        }
    }
    
    public func getBlockedIds(userID: String, completion: @escaping (Result<[String], Error>) -> Void) {
        var ids: [String] = []
        usersRef.document(userID).collection(ProfileURLComponents.Paths.blocked.rawValue).getDocuments { (query, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let query = query else { return }
            query.documents.forEach { doc in
                if let id = doc.data()[ProfileURLComponents.Parameters.id.rawValue] as? String {
                    ids.append(id)
                }
            }
            completion(.success(ids))
        }
    }
}
