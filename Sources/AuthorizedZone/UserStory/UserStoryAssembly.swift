//
//  File.swift
//  
//
//  Created by Арман Чархчян on 24.04.2022.
//

import Foundation
import Swinject
import AuthorizedZoneRouteMap

public final class AuthorizedZoneUserStoryAssembly: Assembly {
    public init() { }
    public func assemble(container: Container) {
        AccountCacheServiceAssembly().assemble(container: container)
        AccountNetworkServiceAssembly().assemble(container: container)
        ProfileInfoNetworkServiceAssembly().assemble(container: container)
        AccountContentNetworkServiceAssembly().assemble(container: container)
        AccountManagerAssembly().assemble(container: container)
        container.register(AuthorizedZoneRouteMap.self) { r in
            AuthorizedZoneUserStory(container: container)
        }
    }
}
