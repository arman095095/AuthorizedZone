//
//  AuthorizedZonePresenter.swift
//  diffibleData
//
//  Created by Арман Чархчян on 22.04.2022.
//  Copyright (c) 2022 Arman Davidoff. All rights reserved.
//

import UIKit
import AlertManager
import Managers

public protocol MainTabbarModuleOutput: AnyObject {
    func openUnauthorizedZone()
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
    private var submodulesConfigurated: Bool
    
    init(router: MainTabbarRouterInput,
         interactor: MainTabbarInteractorInput,
         alertManager: AlertManagerProtocol) {
        self.router = router
        self.interactor = interactor
        self.alertManager = alertManager
        self.submodulesConfigurated = false
    }
}

extension MainTabbarPresenter: MainTabbarViewOutput {
    func viewWillAppear() {
        interactor.refreshAccountInfo()
    }
}

extension MainTabbarPresenter: SubmodulesOutput {
    func openAccountSettingsModule() {
        router.openAccountSettingsModule()
    }
}

extension MainTabbarPresenter: MainTabbarInteractorOutput {

    func successRecovered() {
        router.setupSubmodules(output: self)
    }
    
    func failureRecover(message: String) {
        alertManager.present(type: .error, title: message)
        self.logout()
    }
    
    func profileRemoved() {
        router.openRecoverAlert()
    }
    
    func profileEmpty(message: String) {
        alertManager.present(type: .error, title: message)
        self.logout()
    }
    
    func successRefreshed() {
        guard !submodulesConfigurated else { return }
        router.setupSubmodules(output: self)
    }
    
    func failureRefresh(message: String) {
        alertManager.present(type: .error, title: message)
    }
}

extension MainTabbarPresenter: MainTabbarRouterOutput {
    func submodulesSetuped() {
        submodulesConfigurated = true
    }
    
    func logout() {
        interactor.logout()
        output?.openUnauthorizedZone()
    }
    
    func recoverAccount() {
        interactor.recoverProfile()
    }
}

extension MainTabbarPresenter: MainTabbarModuleInput {
    
}
