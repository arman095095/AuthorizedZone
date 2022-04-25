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
    func openAccountSettingsModule()
}

final class MainTabbarRouter {
    weak var transitionHandler: UITabBarController?
    private let routeMap: RouteMapPrivate
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }
}

extension MainTabbarRouter: MainTabbarRouterInput {
    func setupSubmodules(output: SubmodulesOutput) {
        transitionHandler?.viewControllers = ModuleType.allCases.map {
            let viewController = viewController(output: output, type: $0)
            viewController.tabBarItem.image = UIImage(systemName: $0.imageName)
            viewController.tabBarItem.title = $0.title
            return viewController
        }
    }
    
    func openAccountSettingsModule() {
        let module = routeMap.openAccountSettings()
        transitionHandler?.navigationController?.pushViewController(module.view, animated: true)
    }
}

private extension MainTabbarRouter {
    
    func viewController(output: SubmodulesOutput, type: ModuleType) -> UIViewController {
        switch type {
        case .peoples:
            return UIViewController()
        case .posts:
            return UIViewController()
        case .chats:
            return UIViewController()
        case .profile:
            return accountModule(output: output).view
        }
    }
    
    func accountModule(output: ProfileModuleOutput) -> ModuleProtocol {
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
