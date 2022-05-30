//
//  File.swift
//  
//
//  Created by Арман Чархчян on 30.05.2022.
//

import Foundation
import Swinject
import FirebaseAuth

final class AuthNetworkServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AuthNetworkServiceProtocol.self) { r in
            AuthNetworkService(authNetworkService: Auth.auth())
        }.inObjectScope(.weak)
    }
}
