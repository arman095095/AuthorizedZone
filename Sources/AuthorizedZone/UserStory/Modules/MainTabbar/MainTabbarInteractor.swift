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
    func refreshAccountInfo()
    func recoverProfile()
    func logout()
}

protocol MainTabbarInteractorOutput: AnyObject {
    func profileRemoved()
    func profileEmpty()
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
                switch error {
                case .cantRecover:
                    self?.output?.failureRecover(message: error.localizedDescription)
                default:
                    self?.output?.profileEmpty()
                }
            }
        }
    }
    
    func logout() {
        accountManager.signOut()
    }
    
    func refreshAccountInfo() {
        accountManager.launch { [weak self] result in
            switch result {
            case .success:
                self?.output?.successRefreshed()
            case .failure(let error):
                switch error {
                case .emptyProfile:
                    self?.output?.profileEmpty()
                case .profileRemoved:
                    self?.output?.profileRemoved()
                case .another(error: let error):
                    self?.output?.failureRefresh(message: error.localizedDescription)
                }
            }
        }
    }
}
