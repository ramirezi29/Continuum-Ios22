//
//  CommentModel.swift
//  Continuum-iOS22
//
//  Created by Ivan Ramirez on 11/7/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import Foundation
import CloudKit

class Comment {
    
    var recordID = CKRecord.ID(recordName: UUID().uuidString)
    var text: String
    var timestamp: Date
    weak var post: Post?
    
    // NOTE: - Making nil option allaws us to set it as nil
    init(text: String, timestamp: Date = Date(), post: Post?) {
        self.text = text
        self.timestamp = timestamp
        self.post = post
    }
    
    var timeStampAsString: String {
        return DateFormatter.localizedString(from: timestamp, dateStyle: .short, timeStyle: .none)
    }
    
    convenience required init?(record: CKRecord) {
        guard let text = record[CommentConstants.CommentTextKey] as? String,
            let timestamp = record.creationDate else {return nil}
        self.init(text: text, timestamp: timestamp, post: nil)
        self.recordID = record.recordID
    }
}

extension CKRecord {
    convenience init(_ comment: Comment) {
        guard let post = comment.post else {
            fatalError("\n\nComment does not have a post relationship!\n\n")
        }
        self.init(recordType: CommentConstants.CommentTextKey, recordID: comment.recordID)
        self.setValue(comment.text, forKey: CommentConstants.textKey)
        self.setValue(comment.timestamp, forKey: CommentConstants.timestampKey)
        self.setValue(CKRecord.Reference(recordID: post.recordID, action: .deleteSelf), forKey: CommentConstants.postRefrenceKey)
    }
}
