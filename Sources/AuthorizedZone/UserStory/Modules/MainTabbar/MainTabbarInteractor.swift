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
}

protocol MainTabbarInteractorOutput: AnyObject {
    func successRefreshed(profile: ProfileModelProtocol)
    func failureRefresh(message: String)
}

final class MainTabbarInteractor {
    
    weak var output: MainTabbarInteractorOutput?
    private let authManager: AuthManagerProtocol
    
    init(authManager: AuthManagerProtocol) {
        self.authManager = authManager
    }
}

extension MainTabbarInteractor: MainTabbarInteractorInput {
    func refreshAccountInfo() {
        authManager.getAccount { [weak self] result in
            switch result {
            case .success(let account):
                self?.output?.successRefreshed(profile: account.profile)
            case .failure(let error):
                self?.output?.failureRefresh(message: error.localizedDescription)
            }
        }
    }
}
