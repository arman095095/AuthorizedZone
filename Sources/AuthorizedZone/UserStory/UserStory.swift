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

public protocol AuthorizedZoneModuleProtocol: AnyObject {
    func rootModule() -> ModuleProtocol
}

public final class AuthorizedZoneUserStory {

    var outputWrapper: RootModuleWrapper?
    private let container: Container

    public init(container: Container) {
        self.container = container
    }
}

extension AuthorizedZoneUserStory: AuthorizedZoneModuleProtocol {
    public func rootModule() -> ModuleProtocol {
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
    func mainTabbarModule() -> MainTabbarModule {
        let module = MainTabbarAssembly.makeModule(routeMap: self)
        module._output = outputWrapper
        return module
    }
    
    func openCurrentAccountProfile() -> ModuleProtocol {
        guard let account = container.synchronize().resolve(AuthManagerProtocol.self)?.currentAccount?.profile else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = ProfileUserStory(container: container).currentAccountModule(profile: account)
        module.output = outputWrapper
        return module
    }
}

enum ErrorMessage: LocalizedError {
    case dependency
}
