//
//  AuthorizedZoneInteractor.swift
//  diffibleData
//
//  Created by Арман Чархчян on 22.04.2022.
//  Copyright (c) 2022 Arman Davidoff. All rights reserved.
//

import UIKit

protocol MainTabbarInteractorInput: AnyObject {
    
}

protocol MainTabbarInteractorOutput: AnyObject {
    
}

final class MainTabbarInteractor {
    
    weak var output: MainTabbarInteractorOutput?
}

extension MainTabbarInteractor: MainTabbarInteractorInput {
    
}
