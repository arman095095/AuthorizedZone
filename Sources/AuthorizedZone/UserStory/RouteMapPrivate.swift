//
//  File.swift
//  
//
//  Created by Арман Чархчян on 24.04.2022.
//

import Foundation
import Module

protocol RouteMapPrivate {
    func mainTabbarModule() -> MainTabbarModule
    func openCurrentAccountProfile() -> ModuleProtocol
}
