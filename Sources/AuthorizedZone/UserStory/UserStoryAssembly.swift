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

public final class AuthorizedZoneUserStoryAssembly {
    public static func assemble(container: Container,
                                context: AccountManagerContext) {
        AccountManagerAssembly.assemble(container: container, context: context)
        ProfilesManagerAssembly.assembly(container: container)
    }
}
