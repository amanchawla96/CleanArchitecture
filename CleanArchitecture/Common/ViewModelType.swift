//
//  ViewModelType.swift
//  CleanArchitecture
//
//  Created by Aman Chawla on 24/04/22.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
