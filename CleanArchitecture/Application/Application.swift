//
//  Application.swift
//  CleanArchitecture
//
//  Created by Aman Chawla on 24/04/22.
//

import Foundation
import UIKit
import Domain
import CoreDataPlatform

final class Application {
    static let shared = Application()
    
    private let coreDataProvider: Domain.UseCaseProvider
    
    private init() {
        self.coreDataProvider = CoreDataPlatform.UseCaseProvider()
    }
    
    func configureInterface(in window: UIWindow) {
        let navigationController = UINavigationController()
        let defaultPostsNavigator = DefaultPostsNavigator(navigationController: navigationController, useCaseProvider: coreDataProvider)
        
        window.rootViewController = navigationController
        defaultPostsNavigator.start()
    }
}
