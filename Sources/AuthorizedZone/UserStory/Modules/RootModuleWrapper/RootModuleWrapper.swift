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
import Settings

public protocol AuthorizedZoneModuleInput: AnyObject {
    
}

public protocol AuthorizedZoneModuleOutput: AnyObject {
    func openAuthorization()
}

final class RootModuleWrapper {

    private let routeMap: RouteMapPrivate
    weak var output: AuthorizedZoneModuleOutput?
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }

    func view() -> UIViewController {
        let module = routeMap.mainTabbarModule()
        module.output = self
        return module.view
    }
}

extension RootModuleWrapper: AuthorizedZoneModuleInput {
    
}

extension RootModuleWrapper: MainTabbarModuleOutput {
    func logout() {
        output?.openAuthorization()
    }
}

extension RootModuleWrapper: SettingsModuleOutput {
    
    
    
}
