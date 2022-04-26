//
//  EditPostVM.swift
//  CleanArchitecture
//
//  Created by Aman Chawla on 26/04/22.
//

import Foundation
import Domain
import RxSwift
import RxCocoa

class EditPostVM: ViewModelType {
    
    // MARK: - Data Flow
    struct Input {
        let editTrigger: Driver<Void>
        let deleteTrigger: Driver<Void>
        let title: Driver<String>
        let details: Driver<String>
    }
    
    struct Output {
        let editButtonTitle: Driver<String>
        let save: Driver<Void>
        let delete: Driver<Void>
        let editing: Driver<Bool>
        let post: Driver<Post>
        let error: Driver<Error>
    }
    
    
    //MARK: - Variables & Constents
    private let post: Post
    private let useCase: PostsUseCase
    private let navigator: EditPostNavigator
    
    
    //MARK: - Init
    init(post: Post, useCase: PostsUseCase, navigator: EditPostNavigator) {
        self.post = post
        self.useCase = useCase
        self.navigator = navigator
    }
    
    
    //MARK: - Flow
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let editing = input.editTrigger.scan(false) { editing, _ in
            return !editing
        }.startWith(false)
        
        let saveTrigger = editing.skip(1)
            .filter({ $0 == false })
            .mapToVoid()
        
        let titleAndDetails = Driver.combineLatest(input.title, input.details)
        let post = Driver.combineLatest(Driver.just(self.post), titleAndDetails) { (post, titleAndDetails) -> Post in
            return Post(body: titleAndDetails.1, title: titleAndDetails.0, uid: post.uid, userId: post.userId, createdAt: post.createdAt)
        }.startWith(self.post)
        
        let editButtonTitle = editing.map({ editing -> String in
            return editing == true ? "Save" : "Edit"
        })
        
        let savePost = saveTrigger.withLatestFrom(post)
            .flatMapLatest { post in
                return self.useCase.save(post: post)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        let deletePost = input.deleteTrigger.withLatestFrom(post)
            .flatMapLatest { post in
                self.useCase.delete(post: post)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }.do(onNext: {
                self.navigator.toPost()
            })
                
        return Output(editButtonTitle: editButtonTitle,
                              save: savePost,
                              delete: deletePost,
                              editing: editing,
                              post: post,
                              error: errorTracker.asDriver())
    }
}
