//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import NetworkServices
import Foundation
import Swinject
import UIKit
import ModelInterfaces
import Services
import Managers

public protocol AccountManagerProtocol {
    func observeAccountChanges(completion: @escaping (Bool) -> ())
    func processAccountAfterSuccessAuthorization(account: AccountModelProtocol,
                                                 completion: @escaping (Result<Void, AccountManagerError.Profile>) -> ())
    func processAccountAfterLaunch(completion: @escaping (Result<Void, AccountManagerError.Profile>) -> ())
    func recoverAccount(completion: @escaping (Result<Void, AccountManagerError.Recover>) -> Void)
    func signOut()
}

public enum AccountManagerContext {
    case afterAuthorization(accountID: String, account: AccountModelProtocol)
    case afterLaunch(accountID: String)
}

final class AccountManager {
    private var account: AccountModelProtocol?
    private let accountID: String
    private let authService: AuthNetworkServiceProtocol
    private let accountService: AccountNetworkServiceProtocol
    private let accountInfoService: AccountContentNetworkServiceProtocol
    private let profileService: ProfileInfoNetworkServiceProtocol
    private let container: Container
    private let quickAccessManager: QuickAccessManagerProtocol
    private let cacheService: AccountCacheServiceProtocol
    private var socket: SocketProtocol?
    
    init(accountID: String,
         authService: AuthNetworkServiceProtocol,
         accountService: AccountNetworkServiceProtocol,
         accountInfoService: AccountContentNetworkServiceProtocol,
         quickAccessManager: QuickAccessManagerProtocol,
         profileService: ProfileInfoNetworkServiceProtocol,
         cacheService: AccountCacheServiceProtocol,
         container: Container) {
        self.authService = authService
        self.accountService = accountService
        self.accountInfoService = accountInfoService
        self.quickAccessManager = quickAccessManager
        self.profileService = profileService
        self.cacheService = cacheService
        self.accountID = accountID
        self.container = container
        initObservers()
    }
    
    deinit {
        socket?.remove()
    }
}

extension AccountManager: AccountManagerProtocol {
    
    public func processAccountAfterSuccessAuthorization(account: AccountModelProtocol,
                                                        completion: @escaping (Result<Void, AccountManagerError.Profile>) -> ()) {
        handle(account: account, completion: completion)
    }
    
    public func processAccountAfterLaunch(completion: @escaping (Result<Void, AccountManagerError.Profile>) -> ()) {
        guard let account = cacheService.storedAccount else {
            getAccount { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let account):
                    self.handle(account: account, completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            return
        }
        self.account = account
        self.registerAccount(at: container)
        completion(.success(()))
        getAccount { [weak self] result in
            switch result {
            case .success(let account):
                self?.updateCurrentAccount(with: account)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func observeAccountChanges(completion: @escaping (Bool) -> ()) {
        socket = profileService.initProfileSocket(userID: accountID) { [weak self] result in
            guard let self = self,
                  let account = self.account else { return }
            switch result {
            case .success(let profile):
                self.account?.profile = ProfileModel(profile: profile)
                self.cacheService.store(accountModel: account)
                completion(profile.removed)
            case .failure:
                completion(false)
            }
        }
    }
    
    public func recoverAccount(completion: @escaping (Result<Void, AccountManagerError.Recover>) -> Void) {
        accountService.recoverAccount(accountID: accountID) { [weak self] result in
            guard let self = self,
                  let currentAccount = self.account else { return }
            switch result {
            case .success:
                self.account?.profile.removed = false
                self.cacheService.store(accountModel: currentAccount)
                self.setOnline()
                completion(.success(()))
            case .failure:
                completion(.failure(.cantRecover))
            }
        }
    }
    
    public func signOut() {
        setOffline()
        quickAccessManager.clearAll()
        authService.signOut { _ in }
    }
}

private extension AccountManager {
    
    @objc func setOnline() {
        accountService.setOnline(accountID: accountID)
    }
    
    @objc func setOffline() {
        accountService.setOffline(accountID: accountID)
    }
    
    func getAccount(completion: @escaping (Result<AccountModelProtocol, AccountManagerError.Profile>) -> ()) {
        var profile: ProfileModelProtocol?
        var blockedIDs: [String]?
        var friendIDs: [String]?
        var requestIDs: [String]?
        var waitingsIDs: [String]?
        
        let group = DispatchGroup()
        group.enter()
        profileService.getProfileInfo(userID: accountID) { result in
            defer { group.leave() }
            switch result {
            case .success(let model):
                profile = ProfileModel(profile: model)
            case .failure:
                break
            }
        }
        group.enter()
        accountInfoService.getBlockedIds(userID: accountID) { result in
            defer { group.leave() }
            switch result {
            case .success(let ids):
                blockedIDs = ids
            case .failure:
                break
            }
        }
        group.enter()
        accountInfoService.waitingIDs(userID: accountID) { result in
            defer { group.leave() }
            switch result {
            case .success(let ids):
                waitingsIDs = ids
            case .failure:
                break
            }
        }
        group.enter()
        accountInfoService.requestIDs(userID: accountID) { result in
            defer { group.leave() }
            switch result {
            case .success(let ids):
                requestIDs = ids
            case .failure:
                break
            }
        }
        group.enter()
        accountInfoService.friendIDs(userID: accountID) { result in
            defer { group.leave() }
            switch result {
            case .success(let ids):
                friendIDs = ids
            case .failure:
                break
            }
        }
        group.notify(queue: .main) {
            guard let profile = profile,
                  let blockedIDs = blockedIDs,
                  let waitingsIDs = waitingsIDs,
                  let requestIDs = requestIDs,
                  let friendIDs = friendIDs else {
                completion(.failure(.emptyProfile))
                return
            }
            let account = AccountModel(profile: profile, blockedIDs: Set(blockedIDs), friendIds: Set(friendIDs), waitingsIds: Set(waitingsIDs), requestIds: Set(requestIDs))
            completion(.success(account))
        }
    }
    
    func handle(account: AccountModelProtocol,
                completion: @escaping (Result<Void, AccountManagerError.Profile>) -> ()) {
        self.cacheService.store(accountModel: account)
        self.account = account
        self.registerAccount(at: container)
        guard !account.profile.removed else {
            completion(.failure(.profileRemoved))
            return
        }
        self.accountService.setOnline(accountID: self.accountID)
        completion(.success(()))
    }
    
    func updateCurrentAccount(with account: AccountModelProtocol) {
        self.account?.blockedIds = account.blockedIds
        self.account?.friendIds = account.friendIds
        self.account?.requestIds = account.requestIds
        self.account?.waitingsIds = account.waitingsIds
        self.account?.profile = account.profile
        self.cacheService.store(accountModel: account)
    }
    
    func registerAccount(at container: Container) {
        guard let account = self.account else { return }
        container.register(AccountModelProtocol.self) { _ in
            account
        }.inObjectScope(.weak)
    }
    
    func initObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(setOnline), name: UIScene.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setOffline), name: UIScene.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setOffline), name: UIScene.didDisconnectNotification, object: nil)
    }
}
