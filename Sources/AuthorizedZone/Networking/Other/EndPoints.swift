//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation

struct ProfileURLComponents {

    enum Paths: String {
        case users
        case friendIDs
        case waitingUsers
        case sendedRequests
        case blocked
        case posts
    }

    enum Parameters: String {
        case uid
        case username
        case info
        case sex
        case lastActivity
        case online
        case removed
        case imageURL
        case birthday
        case country
        case city
        case id
    }
}
