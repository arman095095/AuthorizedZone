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
import ProfileRouteMap
import SettingsRouteMap
import AuthorizedZoneRouteMap
import PostsRouteMap

final class RootModuleWrapper {

    private let routeMap: RouteMapPrivate
    weak var output: AuthorizedZoneModuleOutput?
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }

    func view(context: InputFlowContext) -> UIViewController {
        let module = routeMap.mainTabbarModule(context: context)
        module.output = self
        return module.view
    }
}

extension RootModuleWrapper: AuthorizedZoneModuleInput { }

extension RootModuleWrapper: MainTabbarModuleOutput { }

extension RootModuleWrapper: ProfileModuleOutput { }

extension RootModuleWrapper: PostsModuleOutput { }

extension RootModuleWrapper: SettingsModuleOutput {
    func openUnauthorizedZone() {
        output?.openAuthorization()
    }
}
