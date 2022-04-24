//
//  AuthorizedZoneRouter.swift
//  diffibleData
//
//  Created by Арман Чархчян on 22.04.2022.
//  Copyright (c) 2022 Arman Davidoff. All rights reserved.
//

import UIKit
import Module

protocol MainTabbarRouterInput: AnyObject {
    func setupSubmodules()
}

final class MainTabbarRouter {
    weak var transitionHandler: UITabBarController?
}

extension MainTabbarRouter: MainTabbarRouterInput {
    func setupSubmodules() {
        transitionHandler?.viewControllers = ModuleType.allCases.map {
            let viewController = UIViewController()
            //self.module(type: $0).view
            viewController.tabBarItem.image = UIImage(systemName: $0.imageName)
            viewController.tabBarItem.title = $0.title
            return viewController
        }
    }
}

private extension MainTabbarRouter {
    
    func module(type: ModuleType) -> ModuleProtocol? {
        switch type {
        case .peoples:
            return peoplesModule()
        case .posts:
            return postsModule()
        case .chats:
            return chatsModule()
        case .profile:
            return accountModule()
        }
    }
    
    func peoplesModule() -> ModuleProtocol? {
        nil
    }
    
    func chatsModule() -> ModuleProtocol? {
        nil
    }
    
    func postsModule() -> ModuleProtocol? {
        nil
    }
    
    func accountModule() -> ModuleProtocol? {
        nil
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
