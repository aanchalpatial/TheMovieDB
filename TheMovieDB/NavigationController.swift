//
//  NavigationController.swift
//  TheMovieDB
//
//  Created by Aanchal Patial on 16/10/22.
//

import UIKit

class NavigationController: UINavigationController {

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let rootViewController = HomeViewController()
        setViewControllers([rootViewController], animated: true)
    }
}
