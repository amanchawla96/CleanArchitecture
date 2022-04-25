//
//  PostsNavigator.swift
//  CleanArchitecture
//
//  Created by Aman Chawla on 24/04/22.
//

import Foundation
import UIKit
import Domain

protocol PostsNavigator {
    func toCreatePost()
    func toPost(_ post: Post)
    func toPosts()
}

class DefaultPostsNavigator: PostsNavigator {
    
    //MARK: - Variables & Constents
    private let navigationController: UINavigationController
    private let useCaseProvider: UseCaseProvider
    
    
    //MARK: - Init
    init(navigationController: UINavigationController, useCaseProvider: UseCaseProvider) {
        self.navigationController = navigationController
        self.useCaseProvider = useCaseProvider
    }
    
    //MARK: - Controller Builder
    func start() {
        let controller = PostsVC()
        controller.viewModel = PostsVM(useCase: useCaseProvider.makePostsUseCase(), navigator: self)
        navigationController.pushViewController(controller, animated: false)
    }
    
    func toPosts() {
        let controller = PostsVC()
        controller.viewModel = PostsVM(useCase: useCaseProvider.makePostsUseCase(), navigator: self)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toCreatePost() {
        let navigator = DefaultCreatePostNavigator(navigationControler: navigationController)
        let viewModel = CreatePostVM(useCase: useCaseProvider.makePostsUseCase(), navigator: navigator)
        let controller = CreatePostVC()
        controller.viewModel = viewModel
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toPost(_ post: Post) {
        
    }
}
