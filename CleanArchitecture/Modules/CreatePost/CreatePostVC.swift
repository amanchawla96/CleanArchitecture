//
//  CreatePostVC.swift
//  CleanArchitecture
//
//  Created by Aman Chawla on 25/04/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CreatePostVC: UIViewController {
    
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
    
    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .done, target: self, action: nil)
        return button
    }()
    
    private lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: nil)
        return button
    }()
    
    //MARK: - Variables & Constents
    private let disposeBag = DisposeBag()
    
    var viewModel: CreatePostVM!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItems = [cancelButton, saveButton]
        
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
        let input = CreatePostVM.Input(cancelTrigger: cancelButton.rx.tap.asDriver(),
                                       saveTrigger: saveButton.rx.tap.asDriver(),
                                       title: titleTF.rx.text.orEmpty.asDriver(),
                                       details: detailsTV.rx.text.orEmpty.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.dismiss.drive().disposed(by: disposeBag)
        output.saveEnabled.drive(saveButton.rx.isEnabled).disposed(by: disposeBag)
    }
}
