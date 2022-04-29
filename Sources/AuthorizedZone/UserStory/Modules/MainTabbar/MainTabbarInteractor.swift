//
//  AuthorizedZoneInteractor.swift
//  diffibleData
//
//  Created by Арман Чархчян on 22.04.2022.
//  Copyright (c) 2022 Arman Davidoff. All rights reserved.
//

import UIKit
import Managers

protocol MainTabbarInteractorInput: AnyObject {
    func updateAccount()
    func saveAccount(account: AccountModelProtocol)
    func recoverProfile()
    func logout()
}

protocol MainTabbarInteractorOutput: AnyObject {
    func profileRemoved()
    func profileEmpty(message: String)
    func successRefreshed()
    func successRecovered()
    func failureRefresh(message: String)
    func failureRecover(message: String)
}

final class MainTabbarInteractor {
    
    weak var output: MainTabbarInteractorOutput?
    private let accountManager: AccountManagerProtocol
    
    init(accountManager: AccountManagerProtocol) {
        self.accountManager = accountManager
    }
}

extension MainTabbarInteractor: MainTabbarInteractorInput {
    
    func recoverProfile() {
        accountManager.recoverAccount { [weak self] result in
            switch result {
            case .success:
                self?.output?.successRecovered()
            case .failure(let error):
                self?.handle(recoverError: error)
            }
        }
    }
    
    func logout() {
        accountManager.signOut()
    }
    
    func updateAccount() {
        accountManager.processAccountAfterLaunch { [weak self] result in
            switch result {
            case .success:
                self?.output?.successRefreshed()
            case .failure(let error):
                self?.handle(profileError: error)
            }
        }
    }
    
    func saveAccount(account: AccountModelProtocol) {
        accountManager.processAccountAfterSuccessAuthorization(account: account) { [weak self] result in
            switch result {
            case .success:
                self?.output?.successRefreshed()
            case .failure(let error):
                self?.handle(profileError: error)
            }
        }
    }
}

private extension MainTabbarInteractor {
    func handle(profileError: AccountManagerError.Profile) {
        switch profileError {
        case .emptyProfile:
            output?.profileEmpty(message: profileError.localizedDescription)
        case .profileRemoved:
            output?.profileRemoved()
        case .another(error: let error):
            output?.failureRefresh(message: error.localizedDescription)
        }
    }
    
    func handle(recoverError: AccountManagerError.Remove) {
        switch recoverError {
        case .cantRecover:
            output?.failureRecover(message: recoverError.localizedDescription)
        default:
            output?.profileEmpty(message: recoverError.localizedDescription)
        }
    }
}
