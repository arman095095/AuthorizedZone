//
//  RootModuleWrapperAssembly.swift
//  
//
//  Created by Арман Чархчян on 24.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module
import Managers

public typealias AuthorizedZoneModule = Module<AuthorizedZoneModuleInput, AuthorizedZoneModuleOutput>

enum RootModuleWrapperAssembly {
    static func makeModule(routeMap: RouteMapPrivate, context: InputFlowContext) -> AuthorizedZoneModule {
        let wrapper = RootModuleWrapper(routeMap: routeMap)
        return AuthorizedZoneModule(input: wrapper, view: wrapper.view(context: context)) {
            wrapper.output = $0
        }
    }
}
