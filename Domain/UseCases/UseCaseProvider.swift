//
//  UseCaseProvider.swift
//  Domain
//
//  Created by Aman Chawla on 24/04/22.
//

import Foundation

public protocol UseCaseProvider {
    func makePostsUseCase() -> PostsUseCase
}
