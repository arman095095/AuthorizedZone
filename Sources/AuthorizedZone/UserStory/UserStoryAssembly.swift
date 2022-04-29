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
    public static func assemble(container: Container) {
        AccountManagerAssembly.assemble(container: container)
        ProfilesManagerAssembly.assembly(container: container)
    }
}
