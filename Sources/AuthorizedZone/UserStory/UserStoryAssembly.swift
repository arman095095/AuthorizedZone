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

public final class AuthorizedZoneUserStoryAssembly: Assembly {
    public init() { }
    public func assemble(container: Container) {
        container.register(UserStoryFacade.self) { r in
            UserStoryFacade()
        }.initCompleted { resolver, facade in
            facade.postsUserStory = PostsUserStory(container: container)
            facade.profileUserStory = ProfileUserStory(container: container)
            facade.settingsUserStory = SettingsUserStory(container: container)
        }
    }
}
