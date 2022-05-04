//
//  File.swift
//  
//
//  Created by Арман Чархчян on 23.04.2022.
//

import Foundation
import Module
import Swinject
import Managers
import Profile
import Settings
import AlertManager
import Posts

public protocol AuthorizedZoneRouteMap: AnyObject {
    func rootModule(context: InputFlowContext) -> AuthorizedZoneModule
}

public final class AuthorizedZoneUserStory {

    var outputWrapper: RootModuleWrapper?
    private let container: Container

    public init(container: Container) {
        self.container = container
    }
}

extension AuthorizedZoneUserStory: AuthorizedZoneRouteMap {
    public func rootModule(context: InputFlowContext) -> AuthorizedZoneModule {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self, context: context)
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }
}

extension AuthorizedZoneUserStory: RouteMapPrivate {

    func openAccountSettings() -> SettingsModule {
        let module = SettingsUserStory(container: container).rootModule()
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
        let module = ProfileUserStory(container: container).currentAccountModule(profile: accountProfile)
        return module
    }
    
    func openPostsModule() -> PostsModule {
        return PostsUserStory(container: container).allPostsModule()
    }
}

enum ErrorMessage: LocalizedError {
    case dependency
}
