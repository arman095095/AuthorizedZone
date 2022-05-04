//
//  AuthorizedZonePresenter.swift
//  diffibleData
//
//  Created by Арман Чархчян on 22.04.2022.
//  Copyright (c) 2022 Arman Davidoff. All rights reserved.
//

import UIKit
import AlertManager
import Module
import ModelInterfaces

protocol MainTabbarStringFactoryProtocol {
    var successRecoverMessage: String { get }
}

public protocol MainTabbarModuleOutput: AnyObject {
    func openUnauthorizedZone()
}

protocol MainTabbarModuleInput: AnyObject { }

protocol MainTabbarViewOutput: AnyObject {
    func viewWillAppear()
}

public enum InputFlowContext {
    case afterAuthorization(account: AccountModelProtocol)
    case afterLaunch
}

final class MainTabbarPresenter {
    
    weak var view: MainTabbarViewInput?
    weak var output: MainTabbarModuleOutput?
    private let router: MainTabbarRouterInput
    private var context: InputFlowContext
    private let interactor: MainTabbarInteractorInput
    private let alertManager: AlertManagerProtocol
    private let stringFactory: MainTabbarStringFactoryProtocol
    // Костыль, потому что viewDidLoad вызывается у UITabbarController на момент инициализации
    private var tabbarItemsConfigured: Bool
    
    init(router: MainTabbarRouterInput,
         interactor: MainTabbarInteractorInput,
         alertManager: AlertManagerProtocol,
         context: InputFlowContext,
         stringFactory: MainTabbarStringFactoryProtocol) {
        self.router = router
        self.interactor = interactor
        self.alertManager = alertManager
        self.context = context
        self.stringFactory = stringFactory
        self.tabbarItemsConfigured = false
    }
}

extension MainTabbarPresenter: MainTabbarViewOutput {
    func viewWillAppear() {
        guard !tabbarItemsConfigured else { return }
        switch context {
        case .afterAuthorization(let account):
            interactor.saveAccount(account: account)
        case .afterLaunch:
            interactor.updateAccount()
        }
    }
}

extension MainTabbarPresenter: SubmodulesOutput {
    func openAccountSettingsModule() {
        router.openAccountSettingsModule()
    }
}

extension MainTabbarPresenter: MainTabbarInteractorOutput {

    func successRecovered() {
        alertManager.present(type: .success, title: stringFactory.successRecoverMessage)
        configureSubmodulesAndContext()
    }
    
    func successRefreshed() {
        configureSubmodulesAndContext()
    }
    
    func profileRemoved() {
        router.openRecoverAlert()
    }
    
    func profileEmpty(message: String) {
        alertManager.present(type: .error, title: message)
        self.logout()
    }
    
    func failureRefresh(message: String) {
        alertManager.present(type: .error, title: message)
    }
    
    func failureRecover(message: String) {
        alertManager.present(type: .error, title: message)
        self.logout()
    }
}

extension MainTabbarPresenter: MainTabbarRouterOutput {

    func tabbarItemsSetuped() {
        tabbarItemsConfigured = true
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

private extension MainTabbarPresenter {
    func configureSubmodulesAndContext() {
        router.setupTabbarItems(output: self)
        switch context {
        case .afterAuthorization:
            self.context = .afterLaunch
        case .afterLaunch:
            break
        }
    }
}
