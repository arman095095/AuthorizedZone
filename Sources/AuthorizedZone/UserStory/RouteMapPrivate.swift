//
//  File.swift
//  
//
//  Created by Арман Чархчян on 24.04.2022.
//

import Foundation
import SettingsRouteMap
import ProfileRouteMap
import PostsRouteMap

protocol RouteMapPrivate {
    func mainTabbarModule(context: InputFlowContext) -> MainTabbarModule
    func openCurrentAccountProfile() -> ProfileModule
    func openAccountSettings() -> SettingsModule
    func openPostsModule() -> PostsModule
}
