//
//  PostModel.swift
//  Continuum-iOS22
//
//  Created by Ivan Ramirez on 11/7/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit
import CloudKit

class Post {
    
    
    var photoData: Data?
    var timestamp: Date
    var comments: [Comment] = []
    var caption: String
    var tempURL: URL?
    var recordID = CKRecord.ID(recordName: UUID().uuidString)
    
    init(photo: UIImage, timestamp: Date = Date(), comments: [Comment] = [], caption: String) {
        self.caption = caption
        self.comments = comments
        self.timestamp = timestamp
        self.photo = photo
    }
    
    
    // photo to UIImage computed property
    var photo: UIImage? {
        get {
            guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        }
        set {
            photoData = newValue?.jpegData(compressionQuality: 0.6)
        }
    }
    
    // Time stamp computed property
    var timeStampAsString: String {
        return DateFormatter.localizedString(from: timestamp, dateStyle: .short, timeStyle: .none)
    }
    
    var imageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            self.tempURL = fileURL
            do {
                try photoData?.write(to: fileURL)
            } catch let error {
                print("\n\n🚀 There was an error with writing the photo data in: \(#file) \n\n \(#function); \n\n\(error); \n\n\(error.localizedDescription) 🚀\n\n")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    deinit {
        if let url = tempURL {
            do {
                try FileManager.default.removeItem(at: url)
            } catch let error {
                print("\n\n🚀 There was an error with deleting temp file, or may cause memory leak in: \(#file) \n\n \(#function); \n\n\(error); \n\n\(error.localizedDescription) 🚀\n\n")
            }
        }
    }
    
    // NOTE: - 🔥Fetch Create a model object fromR a CKRecord --
    // NOTE: - Use a faliable Init
     init?(record: CKRecord) {
        
        guard let caption = record[PostConstants.captionKey] as? String,
            let timestamp = record.creationDate,
            let imageAsset = record[PostConstants.photoDataKey] as? CKAsset else {return nil}
        
        guard let photoData = try?Data(contentsOf: imageAsset.fileURL) else
        {return nil}
        
        self.caption = caption
        self.timestamp = timestamp
        self.photoData = photoData
        self.comments = []
        self.recordID = record.recordID
    }
}

// NOTE: - Create a CKRecord using our model object -- 🔥Push
extension CKRecord {
    convenience init(_ post: Post) {
        let recordID = post.recordID
        self.init(recordType: PostConstants.PostRecordTypeKey, recordID: recordID)
        self.setValue(post.timestamp, forKey: PostConstants.timestampKey)
        self.setValue(post.imageAsset, forKey: PostConstants.photoDataKey)
        self.setValue(post.caption, forKey: PostConstants.captionKey)
    }
}

