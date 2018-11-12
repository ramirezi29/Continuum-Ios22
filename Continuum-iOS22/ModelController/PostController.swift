//
//  PostController.swift
//  Continuum-iOS22
//
//  Created by Ivan Ramirez on 11/7/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class PostController {
    
    // MARK: - Constants Instances
    
    // shared instance
    let shared = PostController()
    
    // Database
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // Source of truth
    var posts: [Post] = []
    
}

// MARK: - Functions
extension PostController {
    
    
    func addComment(with text: String, to post: Post, completion: @escaping (Comment?) -> Void) {
        let comment = Comment(text: text, post: post)
        post.comments.append(comment)
        
        publicDB.save(CKRecord(comment)) { (record, error) in
            if let error = error {
                print("\n\n🚀 There was an error with adding a comment in: \(#file) \n\n \(#function); \n\n\(error); \n\n\(error.localizedDescription) 🚀\n\n")
                completion(nil)
                return
            }
            completion(comment)
        }
    }
    
    func createPostWith(captionText: String, photo: UIImage, completion: @escaping (Post?) -> Void) {
        let post = Post(photo: photo, caption: captionText)
        self.posts.append(post)
        publicDB.save(CKRecord(post)) { (record, error) in
            if let error = error {
                print("\n\n🚀 There was an error with saving the post record in: \(#file) \n\n \(#function); \n\n\(error); \n\n\(error.localizedDescription) 🚀\n\n")
                completion(nil)
                return
            }
            completion(post)
        }
    }
}
