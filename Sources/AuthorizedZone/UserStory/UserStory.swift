//
//  File.swift
//  
//
//  Created by Арман Чархчян on 23.04.2022.
//

import Foundation
import Module
import Swinject
import ModelInterfaces
import Managers
import ProfileRouteMap
import SettingsRouteMap
import AlertManager
import PostsRouteMap
import UserStoryFacade
import AuthorizedZoneRouteMap

public final class AuthorizedZoneUserStory {

    var outputWrapper: RootModuleWrapper?
    private let container: Container

    public init(container: Container) {
        self.container = container
    }
}

extension AuthorizedZoneUserStory: AuthorizedZoneRouteMap {

    public func rootModuleAfterAuthorization(account: AccountModelProtocol) -> AuthorizedZoneModule {
        rootModule(context: .afterAuthorization(account: account))
    }

    public func rootModuleAfterLaunch() -> AuthorizedZoneModule {
        rootModule(context: .afterLaunch)
    }
}

extension AuthorizedZoneUserStory: RouteMapPrivate {
    
    func rootModule(context: InputFlowContext) -> AuthorizedZoneModule {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self, context: context)
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }

    func openAccountSettings() -> SettingsModule {
        guard let module = container.synchronize().resolve(UserStoryFacade.self)?.settingsUserStory?.rootModule() else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        module.output = outputWrapper
        return module
    }
    
    func mainTabbarModule(context: InputFlowContext) -> MainTabbarModule {
        guard let accountManager = container.synchronize().resolve(AccountManagerProtocol.self),
              let alertManager = container.synchronize().resolve(AlertManagerProtocol.self) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = MainTabbarAssembly.makeModule(routeMap: self,
                                                   accountManager: accountManager,
                                                   alertManager: alertManager,
                                                   context: context)
        module.output = outputWrapper
        return module
    }
    
    func openCurrentAccountProfile() -> ProfileModule {
        guard let accountProfile = container.synchronize().resolve(AccountModelProtocol.self)?.profile else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        guard let module = container.synchronize().resolve(UserStoryFacade.self)?.profileUserStory?.currentAccountModule(profile: accountProfile) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        return module
    }
    
    func openPostsModule() -> PostsModule {
        guard let module = container.synchronize().resolve(UserStoryFacade.self)?.postsUserStory?.allPostsModule() else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        return module
    }
}

enum ErrorMessage: LocalizedError {
    case dependency
}
