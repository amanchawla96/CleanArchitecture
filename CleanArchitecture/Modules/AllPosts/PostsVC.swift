//
//  PostsVC.swift
//  CleanArchitecture
//
//  Created by Aman Chawla on 24/04/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PostsVC: UIViewController {
    
    //MARK: - Views
    let tableView: UITableView = {
        let tb = UITableView()
        tb.refreshControl = UIRefreshControl()
        tb.estimatedRowHeight = 64
        tb.rowHeight = UITableView.automaticDimension
        tb.register(PostTVC.self, forCellReuseIdentifier: "PostTVC")
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    lazy var createButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: nil)
        return button
    }()
    
    //MARK: - Variables & Constents
    private let disposeBag = DisposeBag()
    
    var viewModel: PostsVM!
    
    
    //MARK: - LifeCycle
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
        
        title = "Posts"
        
        navigationItem.rightBarButtonItem = createButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        bindViewModel()
    }
    
    //MARK: - View Setup
    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    private func bindViewModel() {
        /// input
        let viewWillAppear = rx.sentMessage(#selector(viewWillAppear(_:))).mapToVoid().asDriverOnErrorJustComplete()
        let pull = tableView.refreshControl!.rx.controlEvent(.valueChanged).asDriver()
        
        let input = PostsVM.Input(trigger: Driver.merge(viewWillAppear, pull),
                                  createPostTrigger: createButton.rx.tap.asDriver(),
                                  selection: tableView.rx.itemSelected.asDriver())
        
        /// output
        let output = viewModel.transform(input: input)
        
        output.posts.drive(tableView.rx.items(cellIdentifier: "PostTVC", cellType: PostTVC.self)) { tv, viewModel, cell in
            cell.bind(viewModel)
        }.disposed(by: disposeBag)
        
        output.fetching.drive(tableView.refreshControl!.rx.isRefreshing).disposed(by: disposeBag)
        output.createPost.drive().disposed(by: disposeBag)
        output.selectedPost.drive().disposed(by: disposeBag)
    }
}
