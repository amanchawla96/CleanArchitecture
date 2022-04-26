//
//  EditPostNavigator.swift
//  CleanArchitecture
//
//  Created by Aman Chawla on 26/04/22.
//

import Foundation
import UIKit

protocol EditPostNavigator {
    func toPost()
}

class DefaultEditPostNavigator: EditPostNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toPost() {
        navigationController.popViewController(animated: true)
    }
}
