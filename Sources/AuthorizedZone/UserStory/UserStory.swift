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

public protocol AuthorizedZoneModuleProtocol: AnyObject {
    func rootModule() -> AuthorizedZoneModule
}

public final class AuthorizedZoneUserStory {

    var outputWrapper: RootModuleWrapper?
    private let container: Container

    public init(container: Container) {
        self.container = container
    }
}

extension AuthorizedZoneUserStory: AuthorizedZoneModuleProtocol {
    public func rootModule() -> AuthorizedZoneModule {
        guard let authManager = container.synchronize().resolve(AuthManagerProtocol.self) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = RootModuleWrapperAssembly.makeModule(authManager: authManager,
                                                          routeMap: self)
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
    
    func mainTabbarModule() -> MainTabbarModule {
        guard let authManager = container.synchronize().resolve(AuthManagerProtocol.self),
              let alertManager = container.synchronize().resolve(AlertManagerProtocol.self) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = MainTabbarAssembly.makeModule(routeMap: self,
                                                   authManager: authManager,
                                                   alertManager: alertManager)
        module.output = outputWrapper
        return module
    }
    
    func openCurrentAccountProfile() -> ProfileModule {
        guard let account = container.synchronize().resolve(AuthManagerProtocol.self)?.currentAccount?.profile else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = ProfileUserStory(container: container).currentAccountModule(profile: account)
        return module
    }
}

enum ErrorMessage: LocalizedError {
    case dependency
}
