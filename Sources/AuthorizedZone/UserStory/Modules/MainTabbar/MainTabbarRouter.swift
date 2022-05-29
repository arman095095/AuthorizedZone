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
import ChatsRouteMap
import ProfilesListRouteMap

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
                viewController = profilesListModule().view
            case .posts:
                viewController = postsModule(output: output).view
            case .chats:
                viewController = chatsModule(output: output).view
                let _ = viewController.view
            case .profile:
                viewController = accountModule(output: output).view
            }
            viewController.tabBarItem.itemType = $0
            return viewController
        }
        transitionHandler?.selectedIndex = UITabBarItem.ModuleType.peoples.rawValue
        self.output?.tabbarItemsSetuped()
    }
}

private extension MainTabbarRouter {
    
    func profilesListModule() -> ProfilesListModule {
        routeMap.openProfilesListModule()
    }
    
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
    
    func chatsModule(output: MainTabbarModuleOutput) -> ChatsModule {
        let module = routeMap.openChatsModule()
        module.output = output as? ChatsModuleOutput
        return module
    }
}

extension UITabBarItem {
    enum ModuleType: Int, CaseIterable {
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
    
    var itemType: ModuleType? {
        set {
            guard let type = newValue else { return }
            image = UIImage(systemName: type.imageName)
            title = type.title
        }
        get {
            switch title {
            case ModuleType.peoples.title:
                return .peoples
            case ModuleType.profile.title:
                return .profile
            case ModuleType.chats.title:
                return .chats
            case ModuleType.posts.title:
                return .posts
            default:
                return nil
            }
        }
    }
}
