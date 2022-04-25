//
//  RootModuleWrapper.swift
//  
//
//  Created by Арман Чархчян on 24.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module
import Managers
import Profile

public protocol AuthorizedZoneModuleInput: AnyObject {
    
}

public protocol AuthorizedZoneModuleOutput: AnyObject {
    func openAuthorization()
    func openAccountsSettings()
}

final class RootModuleWrapper {

    private let routeMap: RouteMapPrivate
    private let authManager: AuthManagerProtocol
    weak var output: AuthorizedZoneModuleOutput?
    
    init(routeMap: RouteMapPrivate,
         authManager: AuthManagerProtocol) {
        self.routeMap = routeMap
        self.authManager = authManager
    }

    func view() -> UIViewController {
        let module = routeMap.mainTabbarModule()
        module._output = self
        return module.view
    }
}

extension RootModuleWrapper: AuthorizedZoneModuleInput {
    
}

extension RootModuleWrapper: ProfileModuleOutput {
    func openAccountSettingsModule() {
        output?.openAccountsSettings()
    }
}

extension RootModuleWrapper: MainTabbarModuleOutput {
    func logout() {
        authManager.signOut()
        output?.openAuthorization()
    }
}
