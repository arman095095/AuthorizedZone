//
//  AuthorizedZoneRouter.swift
//  diffibleData
//
//  Created by Арман Чархчян on 22.04.2022.
//  Copyright (c) 2022 Arman Davidoff. All rights reserved.
//

import UIKit
import Module
import ProfileRouteMap
import SettingsRouteMap
import PostsRouteMap

typealias SubmodulesOutput = ProfileModuleOutput & PostsModuleOutput

protocol MainTabbarRouterInput: AnyObject {
    func setupTabbarItems(output: MainTabbarModuleOutput)
    func openRecoverAlert()
}

protocol MainTabbarRouterOutput: AnyObject {
    func logout()
    func recoverAccount()
    func tabbarItemsSetuped()
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
    
    func setupTabbarItems(output: MainTabbarModuleOutput) {
        transitionHandler?.viewControllers = UITabBarItem.ModuleType.allCases.map {
            var viewController: UIViewController
            switch $0 {
            case .peoples:
                viewController = UIViewController()
            case .posts:
                viewController = postsModule(output: output).view
            case .chats:
                viewController = UIViewController()
            case .profile:
                viewController = accountModule(output: output).view
            }
            viewController.tabBarItem.itemType = $0
            return viewController
        }
        self.output?.tabbarItemsSetuped()
    }
}

private extension MainTabbarRouter {
    
    func accountModule(output: MainTabbarModuleOutput) -> ProfileModule {
        let module = routeMap.openCurrentAccountProfile()
        module.output = output as? ProfileModuleOutput
        return module
    }
    
    func postsModule(output: MainTabbarModuleOutput) -> PostsModule {
        let module = routeMap.openPostsModule()
        module.output = output as? PostsModuleOutput
        return module
    }
}

extension UITabBarItem {
    enum ModuleType: String, CaseIterable {
        case peoples = "Знакомства"
        case posts = "Лента"
        case chats = "Чаты"
        case profile = "Профиль"
        
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
    
    var itemType: ModuleType? {
        set {
            guard let type = newValue else { return }
            image = UIImage(systemName: type.imageName)
            title = type.rawValue
        }
        
        get {
            guard let title = title else { return nil }
            return ModuleType(rawValue: title)
        }
    }
}
