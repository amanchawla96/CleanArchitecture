//
//  PostTVC.swift
//  CleanArchitecture
//
//  Created by Aman Chawla on 25/04/22.
//

import Foundation
import UIKit

class PostTVC: UITableViewCell {
    
    //MARK: - Views
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Subview
    private func setupSubviews() {
        addSubview(titleLbl)
        addSubview(subtitle)
        
        titleLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        titleLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        
        subtitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        subtitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        
        titleLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        titleLbl.bottomAnchor.constraint(equalTo: subtitle.topAnchor, constant: -4).isActive = true
        subtitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
    }
    
    //MARK: - Bind
    func bind(_ viewModel: PostItemVM) {
        self.titleLbl.text = viewModel.title
        self.subtitle.text = viewModel.subtitle
    }
}
