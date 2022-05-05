//
//  File.swift
//  
//
//  Created by Арман Чархчян on 24.04.2022.
//

import Foundation
import Managers
import Settings
import Swinject
import UserStoryFacade
import Posts
import Profile
import AuthorizedZoneRouteMap

public final class AuthorizedZoneUserStoryAssembly: Assembly {
    public init() { }
    public func assemble(container: Container) {
        container.register(AuthorizedZoneRouteMap.self) { r in
            AuthorizedZoneUserStory(container: container)
        }
    }
}
