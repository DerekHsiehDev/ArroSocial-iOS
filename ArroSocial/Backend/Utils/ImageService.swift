//
//  ImageManager.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/15/22.
//

import Foundation
import FirebaseStorage // holds images and videos of app
import UIKit

class ImageService {
    // MARK: PROPERTIES
    
    static let instance = ImageService()
        
    private var REF_STORAGE = Storage.storage()
    
    // MARK: PUBLIC FUNCTIONS
    
    func uploadProfileImage(userID: String, image: UIImage) {
        // get path to saved image
        let path = getProfileImagePath(userID: userID)
        
        // upload image to path
        
        
        uploadImage(path: path, image: image) { success in
            
        }
        
    }
    
    func uploadPostImage(postID: String, image: UIImage, imageCount: Int, handler: @escaping(_ isSuccessful: Bool) -> ()) {
        
        let path = getPostImagePath(postID: postID, imageCount: imageCount)
        
        uploadImage(path: path, image: image) { success in
            if success {
                handler(true)
                return
            } else {
               handler(false)
                return
            }
        }
        
    }
    
    
    // MARK: PRIVATE FUNCTIONS
    
    /// returns Firebase storage path reference from user id
    /// - Parameter userID: User's unique user id
    /// - Returns: returns a firebasestorage reference
    private func getProfileImagePath(userID: String) -> StorageReference {
        let userPath = "users/\(userID)/profile"
        
        let storagePath = REF_STORAGE.reference(withPath: userPath)
        
        return storagePath
    }
    
    private func getPostImagePath(postID: String, imageCount: Int) -> StorageReference {
        // image count is for possible post with multiple pictures
        let postPath = "posts/\(postID)/\(imageCount)"
        
        let storagePath = REF_STORAGE.reference(withPath: postPath)
        
        return storagePath
    }
    
    
    
    private func uploadImage(path: StorageReference, image: UIImage, handler: @escaping(_ success: Bool) -> ()) {
        
        var compression: CGFloat = 1.0 // loops down by 0.05
        let maxFileSize: Int = 240 * 240 // max file size that is saved
        let maxCompresion: CGFloat = 0.05 // max compression allowed
        
        // get image data
        guard var originalData = image.jpegData(compressionQuality: 1.0) else {
            print("Error getting data from image (IMAGE MANAGER - UPLOAD IAMGE)")
            handler(false)
            return
        }
        
        // check max file size
        while (originalData.count > maxFileSize) && (compression > maxCompresion) {
            // lower compression if original data bigger than max file size
            compression -= 0.05
            
            if let compressedData = image.jpegData(compressionQuality: compression) {
                originalData = compressedData
            }
        }
        
        // get photo metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        
        // uploading data to storage path
        path.putData(originalData, metadata: metadata) { _, error in
            if let error = error {
                // error
                print("error uploading image. \(error) (IMAGE MANAGER - UPLOAD IMAGE)")
                handler(false)
                return
            } else {
                // success
                print("successfully uploaded image")
                handler(true)
                return
            }
        }
    }
    
}
