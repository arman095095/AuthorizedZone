//
//  AuthorizedZoneViewController.swift
//  diffibleData
//
//  Created by Арман Чархчян on 22.04.2022.
//  Copyright (c) 2022 Arman Davidoff. All rights reserved.
//

import UIKit
import DesignSystem

protocol MainTabbarViewInput: AnyObject { }

final class MainTabbarController: UITabBarController {
    var output: MainTabbarViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.viewWillAppear()
    }
}

private extension MainTabbarController {
    
    struct Constants {
        static let imageConfig = UIImage.SymbolConfiguration(weight: .bold)
        static let atributesFont = [NSAttributedString.Key.font: UIFont.avenir13()] as [NSAttributedString.Key : Any]
    }
    
    func setupViews() {
        view.backgroundColor = .white
        tabBar.barTintColor = .systemGray6
        tabBar.layer.borderWidth = 0
        tabBar.clipsToBounds = true
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.5450980392, green: 0.4509803922, blue: 0.937254902, alpha: 1)
        tabBar.tintColor = #colorLiteral(red: 0.7772225649, green: 0.1716628475, blue: 1, alpha: 1)
        tabBarItem.setTitleTextAttributes(Constants.atributesFont, for: .normal)
    }
}

extension MainTabbarController: MainTabbarViewInput { }
