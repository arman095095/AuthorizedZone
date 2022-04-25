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

protocol MainTabbarRouterInput: AnyObject {
    func setupSubmodules()
}

final class MainTabbarRouter {
    weak var transitionHandler: UITabBarController?
    private let routeMap: RouteMapPrivate
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }
}

extension MainTabbarRouter: MainTabbarRouterInput {
    func setupSubmodules() {
        transitionHandler?.viewControllers = ModuleType.allCases.map {
            let viewController = viewController(type: $0)
            viewController.tabBarItem.image = UIImage(systemName: $0.imageName)
            viewController.tabBarItem.title = $0.title
            return viewController
        }
    }
}

private extension MainTabbarRouter {
    
    func viewController(type: ModuleType) -> UIViewController {
        switch type {
        case .peoples:
            return UIViewController()
        case .posts:
            return UIViewController()
        case .chats:
            return UIViewController()
        case .profile:
            return accountModule().view
        }
    }
    
    func accountModule() -> ModuleProtocol {
        routeMap.openCurrentAccountProfile()
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
