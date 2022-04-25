//
//  CreatePostVM.swift
//  CleanArchitecture
//
//  Created by Aman Chawla on 25/04/22.
//

import Foundation
import Domain
import RxSwift
import RxCocoa

class CreatePostVM: ViewModelType {
    
    // MARK: - Data Flow
    struct Input {
        let cancelTrigger: Driver<Void>
        let saveTrigger: Driver<Void>
        let title: Driver<String>
        let details: Driver<String>
    }
    
    struct Output {
        let dismiss: Driver<Void>
        let saveEnabled: Driver<Bool>
    }
    
    
    //MARK: - Variables & Constents
    private let useCase: PostsUseCase
    private let navigator: CreatePostNavigator
    
    
    //MARK: - Init
    init(useCase: PostsUseCase, navigator: CreatePostNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    
    //MARK: - Flow
    func transform(input: Input) -> Output {
        let titleAndDetails = Driver.combineLatest(input.title, input.details)
        let activityIndicator = ActivityIndicator()
        
        let canSave = Driver.combineLatest(titleAndDetails, activityIndicator.asDriver()) {
            return !$0.0.isEmpty && !$0.1.isEmpty && !$1
        }
        
        let save = input.saveTrigger.withLatestFrom(titleAndDetails)
            .map { (title, content) in
                return Post(body: content, title: title)
            }
            .flatMapLatest { [unowned self] in
                return self.useCase.save(post: $0)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        
        let dismiss = Driver.of(save, input.cancelTrigger)
            .merge()
            .do(onNext: navigator.toPosts)
        
        return Output(dismiss: dismiss, saveEnabled: canSave)
    }
}
