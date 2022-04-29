//
//  AuthorizedZoneRouter.swift
//  diffibleData
//
//  Created by Арман Чархчян on 22.04.2022.
//  Copyright (c) 2022 Arman Davidoff. All rights reserved.
//

import UIKit
import Module
import Profile
import Settings

typealias SubmodulesOutput = ProfileModuleOutput

protocol MainTabbarRouterInput: AnyObject {
    func setupSubmodules(output: SubmodulesOutput)
    func openRecoverAlert()
    func openAccountSettingsModule()
}

protocol MainTabbarRouterOutput: AnyObject {
    func logout()
    func recoverAccount()
    func submodulesSetuped()
}

final class MainTabbarRouter {
    weak var transitionHandler: UITabBarController?
    weak var output: MainTabbarRouterOutput?
    private let routeMap: RouteMapPrivate
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }
}

extension MainTabbarRouter: MainTabbarRouterInput {

    func openRecoverAlert() {
        transitionHandler?.showAlertForRecover(acceptHandler: {
            self.output?.recoverAccount()
        }, denyHandler: {
            self.output?.logout()
        })
    }
    
    func setupSubmodules(output: SubmodulesOutput) {
        transitionHandler?.viewControllers = ModuleType.allCases.map {
            var viewController: UIViewController
            switch $0 {
            case .profile:
                viewController = accountModule(output: output).view
            default:
                viewController = UIViewController()
            }
            viewController.tabBarItem.image = UIImage(systemName: $0.imageName)
            viewController.tabBarItem.title = $0.title
            return viewController
        }
        self.output?.submodulesSetuped()
    }
    
    func openAccountSettingsModule() {
        let module = routeMap.openAccountSettings()
        transitionHandler?.navigationController?.pushViewController(module.view, animated: true)
    }
}

private extension MainTabbarRouter {
    
    func accountModule(output: ProfileModuleOutput) -> ProfileModule {
        let module = routeMap.openCurrentAccountProfile()
        module.output = output
        return module
    }
    
    enum ModuleType: String, CaseIterable {
        case peoples
        case posts
        case chats
        case profile
        
        var title: String {
            switch self {
            case .peoples:
                return "Знакомства"
            case .posts:
                return "Лента"
            case .chats:
                return "Чаты"
            case .profile:
                return "Профиль"
            }
        }
        
        var imageName: String {
            switch self {
            case .peoples:
                return "person.2"
            case .posts:
                return "list.dash"
            case .chats:
                return "bubble.left.and.bubble.right.fill"
            case .profile:
                return "person.crop.circle.fill"
            }
        }
    }
}
