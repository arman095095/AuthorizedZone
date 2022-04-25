//
//  File.swift
//  
//
//  Created by Арман Чархчян on 24.04.2022.
//

import Foundation
import Settings
import Profile

protocol RouteMapPrivate {
    func mainTabbarModule() -> MainTabbarModule
    func openCurrentAccountProfile() -> ProfileModule
    func openAccountSettings() -> SettingsModule
}
