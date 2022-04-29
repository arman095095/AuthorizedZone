//
//  AuthorizedZoneAssembly.swift
//  diffibleData
//
//  Created by Арман Чархчян on 22.04.2022.
//  Copyright (c) 2022 Arman Davidoff. All rights reserved.
//

import UIKit
import Module
import Managers
import AlertManager

typealias MainTabbarModule = Module<MainTabbarModuleInput, MainTabbarModuleOutput>

enum MainTabbarAssembly {
    static func makeModule(routeMap: RouteMapPrivate,
                           accountManager: AccountManagerProtocol,
                           alertManager: AlertManagerProtocol,
                           context: InputFlowContext) -> MainTabbarModule {
        let view = MainTabbarController()
        let router = MainTabbarRouter(routeMap: routeMap)
        let interactor = MainTabbarInteractor(accountManager: accountManager)
        let stringFactory = AuthorizedZoneStringFactory()
        let presenter = MainTabbarPresenter(router: router,
                                            interactor: interactor,
                                            alertManager: alertManager,
                                            context: context,
                                            stringFactory: stringFactory)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.output = presenter
        router.transitionHandler = view
        return MainTabbarModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}
