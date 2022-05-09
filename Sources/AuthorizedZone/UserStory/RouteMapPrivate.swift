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
import ChatsRouteMap

protocol RouteMapPrivate {
    func mainTabbarModule(context: InputFlowContext) -> MainTabbarModule
    func openCurrentAccountProfile() -> ProfileModule
    func openAccountSettings() -> SettingsModule
    func openPostsModule() -> PostsModule
    func openChatsModule() -> ChatsModule
    //func profilesSendOffersModule() -> ProfileModule
}
