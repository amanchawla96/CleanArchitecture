//
//  PostItemVM.swift
//  CleanArchitecture
//
//  Created by Aman Chawla on 24/04/22.
//

import Foundation
import Domain

final class PostItemVM   {
    let title:String
    let subtitle : String
    let post: Post
    init (with post:Post) {
        self.post = post
        self.title = post.title.uppercased()
        self.subtitle = post.body
    }
}
