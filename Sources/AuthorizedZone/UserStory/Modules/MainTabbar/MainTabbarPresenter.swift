//
//  AuthorizedZonePresenter.swift
//  diffibleData
//
//  Created by Арман Чархчян on 22.04.2022.
//  Copyright (c) 2022 Arman Davidoff. All rights reserved.
//

import UIKit

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
    
    init(router: MainTabbarRouterInput,
         interactor: MainTabbarInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension MainTabbarPresenter: MainTabbarViewOutput {
    func viewWillAppear() {
        view?.setupInitialState()
        router.setupSubmodules()
    }
}

extension MainTabbarPresenter: MainTabbarInteractorOutput {
    
}

extension MainTabbarPresenter: MainTabbarModuleInput {
    
}
