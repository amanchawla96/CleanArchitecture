//
//  CreatePostNavigator.swift
//  CleanArchitecture
//
//  Created by Aman Chawla on 25/04/22.
//

import Foundation
import UIKit

protocol CreatePostNavigator {
    func toPosts()
}

class DefaultCreatePostNavigator: CreatePostNavigator {
    private let navigationControler: UINavigationController
    
    init(navigationControler: UINavigationController) {
        self.navigationControler = navigationControler
    }
    
    func toPosts() {
        navigationControler.popViewController(animated: true)
    }
}
