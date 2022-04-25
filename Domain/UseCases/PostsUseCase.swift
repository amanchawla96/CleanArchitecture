//
//  PostsUseCase.swift
//  Domain
//
//  Created by Aman Chawla on 24/04/22.
//

import Foundation
import RxSwift

public protocol PostsUseCase {
    func posts() -> Observable<[Post]>
    func save(post: Post) -> Observable<Void>
    func delete(post: Post) -> Observable<Void>
}
