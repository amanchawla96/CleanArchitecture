//
//  UseCaseProvider.swift
//  CoreDataPlatform
//
//  Created by Aman Chawla on 24/04/22.
//

import Foundation
import Domain

public final class UseCaseProvider: Domain.UseCaseProvider {
    private let coreDataStack = CoreDataStack()
    private let postRepository: Repository<Post>
    
    public init() {
        postRepository = Repository<Post>(context: coreDataStack.context)
    }
    
    public func makePostsUseCase() -> Domain.PostsUseCase {
        return PostsUseCase(repository: postRepository)
    }
}
