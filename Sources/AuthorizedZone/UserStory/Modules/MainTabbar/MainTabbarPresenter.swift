//
//  AuthorizedZonePresenter.swift
//  diffibleData
//
//  Created by Арман Чархчян on 22.04.2022.
//  Copyright (c) 2022 Arman Davidoff. All rights reserved.
//

import UIKit
import AlertManager

public protocol MainTabbarModuleOutput: AnyObject {
    func logout()
}

protocol MainTabbarModuleInput: AnyObject {
    
}

protocol MainTabbarViewOutput: AnyObject {
    func viewWillAppear()
}

final class MainTabbarPresenter {
    
    weak var view: MainTabbarViewInput?
    weak var output: MainTabbarModuleOutput?
    private let router: MainTabbarRouterInput
    private let interactor: MainTabbarInteractorInput
    private let alertManager: AlertManagerProtocol
    
    init(router: MainTabbarRouterInput,
         interactor: MainTabbarInteractorInput,
         alertManager: AlertManagerProtocol) {
        self.router = router
        self.interactor = interactor
        self.alertManager = alertManager
    }
}

extension MainTabbarPresenter: MainTabbarViewOutput {
    func viewWillAppear() {
        view?.setupInitialState()
        interactor.refreshAccountInfo()
        router.setupSubmodules(output: self)
    }
}

extension MainTabbarPresenter: SubmodulesOutput {
    func openAccountSettingsModule() {
        router.openAccountSettingsModule()
    }
}

extension MainTabbarPresenter: MainTabbarInteractorOutput {
    func successRefreshed(profile: ProfileModelProtocol) {
        router.setupSubmodules(output: self, with: profile)
    }
    
    func failureRefresh(message: String) {
        alertManager.present(type: .error, title: message)
    }
}

extension MainTabbarPresenter: MainTabbarModuleInput {
    
}
