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

public protocol AuthorizedZoneModuleInput: AnyObject {
    
}

public protocol AuthorizedZoneModuleOutput: AnyObject {
    func openAuthorization()
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

    func view() -> UINavigationController {
        let module = routeMap.mainTabbarModule()
        module._output = self
        return UINavigationController(rootViewController: module.view)
    }
}

extension RootModuleWrapper: AuthorizedZoneModuleInput {
    
}

extension RootModuleWrapper: MainTabbarModuleOutput {
    func logout() {
        authManager.signOut()
        output?.openAuthorization()
    }
}
