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
    func successRefreshed()
    func failureRefresh(message: String)
}

final class MainTabbarInteractor {
    
    weak var output: MainTabbarInteractorOutput?
    private let accountManager: AccountManagerProtocol
    
    init(accountManager: AccountManagerProtocol) {
        self.accountManager = accountManager
    }
}

extension MainTabbarInteractor: MainTabbarInteractorInput {
    func refreshAccountInfo() {
        accountManager.launch { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                switch error {
                case .another(error: let error):
                    break
                case .profile(value: let value):
                    break
                case .remove(value: let value):
                    break
                case .blocking(value: let value):
                    break
                }
            }
        }
    }
}
