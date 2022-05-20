//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation
import Swinject
import NetworkServices
import Services
import Managers

final class AccountManagerAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(AccountManagerProtocol.self) { r in
            guard let accountService = r.resolve(AccountNetworkServiceProtocol.self),
                  let quickAccessManager = r.resolve(QuickAccessManagerProtocol.self),
                  let profileService = r.resolve(ProfileInfoNetworkServiceProtocol.self),
                  let accountInfoService = r.resolve(AccountContentNetworkServiceProtocol.self),
                  let cacheService = r.resolve(AccountCacheServiceProtocol.self),
                  let accountID = quickAccessManager.userID else { fatalError(ErrorMessage.dependency.localizedDescription)
            }
            return AccountManager(accountID: accountID,
                                  accountService: accountService,
                                  accountInfoService: accountInfoService,
                                  quickAccessManager: quickAccessManager,
                                  profileService: profileService,
                                  cacheService: cacheService,
                                  container: container)
        }.inObjectScope(.weak)
    }
}
