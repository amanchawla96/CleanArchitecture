//
//  EditPostVC.swift
//  CleanArchitecture
//
//  Created by Aman Chawla on 26/04/22.
//

import Foundation
import UIKit
import Domain
import RxSwift
import RxCocoa

class EditPostVC: UIViewController {
    
    //MARK: - Views
    private lazy var titleTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "enter title..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var detailsTV: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: nil)
        return button
    }()
    
    private lazy var deleteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: nil)
        return button
    }()
    
    //MARK: - Variables & Constents
    private let disposeBag = DisposeBag()
    
    var viewModel: EditPostVM!
    
    var postBinding: Binder<Post> {
        return Binder(self, binding: { (vc, post) in
            vc.titleTF.text = post.title
            vc.detailsTV.text = post.body
            vc.title = post.title
        })
    }
    
    var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, _) in
            let alert = UIAlertController(title: "Save Error",
                                          message: "Something went wrong",
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss",
                                       style: UIAlertAction.Style.cancel,
                                       handler: nil)
            alert.addAction(action)
            vc.present(alert, animated: true, completion: nil)
        })
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItems = [deleteButton, editButton]
        
        setupSubviews()
        bindViewModel()
    }
    
    
    //MARK: - Setup
    private func setupSubviews() {
        view.addSubview(titleTF)
        view.addSubview(detailsTV)
        
        titleTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        titleTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        titleTF.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleTF.bottomAnchor.constraint(equalTo: detailsTV.topAnchor, constant: -4).isActive = true
        
        detailsTV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        detailsTV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        detailsTV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
    }
    
    private func bindViewModel() {
        let deleteTrigger = deleteButton.rx.tap.flatMap {
            return Observable<Void>.create { observer in
                
                let alert = UIAlertController(title: "Delete Post",
                                              message: "Are you sure you want to delete this post?",
                                              preferredStyle: .alert
                )
                let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { _ -> () in observer.onNext(()) })
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alert.addAction(yesAction)
                alert.addAction(noAction)
                
                self.present(alert, animated: true, completion: nil)
                
                return Disposables.create()
            }
        }
        
        let input = EditPostVM.Input(
            editTrigger: editButton.rx.tap.asDriver(),
            deleteTrigger: deleteTrigger.asDriverOnErrorJustComplete(),
            title: titleTF.rx.text.orEmpty.asDriver(),
            details: detailsTV.rx.text.orEmpty.asDriver()
        )
        
        let output = viewModel.transform(input: input)
        
        [output.editButtonTitle.drive(editButton.rx.title),
         output.editing.drive(titleTF.rx.isEnabled),
         output.editing.drive(detailsTV.rx.isEditable),
         output.post.drive(postBinding),
         output.save.drive(),
         output.error.drive(errorBinding),
         output.delete.drive()]
            .forEach({$0.disposed(by: disposeBag)})
    }
}

extension Reactive where Base: UITextView {
    var isEditable: Binder<Bool> {
        return Binder(self.base, binding: { (textView, isEditable) in
            textView.isEditable = isEditable
        })
    }
}
