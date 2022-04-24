//
//  AuthorizedZoneAssembly.swift
//  diffibleData
//
//  Created by Арман Чархчян on 22.04.2022.
//  Copyright (c) 2022 Arman Davidoff. All rights reserved.
//

import UIKit
import Module

typealias MainTabbarModule = Module<MainTabbarModuleInput, MainTabbarModuleOutput>

enum MainTabbarAssembly {
    static func makeModule() -> MainTabbarModule {
        let view = MainTabbarController()
        let router = MainTabbarRouter()
        let interactor = MainTabbarInteractor()
        let presenter = MainTabbarPresenter(router: router,
                                          interactor: interactor)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.transitionHandler = view
        return MainTabbarModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}
