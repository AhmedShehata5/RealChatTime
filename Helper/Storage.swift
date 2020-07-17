//
//  Storage.swift
//  MyChatTest
//
//  Created by Mohamed Arafa on 3/23/20.
//  Copyright © 2020 SolxFy. All rights reserved.
//

import Foundation
import FirebaseStorage
import Firebase
import MBProgressHUD


let storage = Storage.storage()
let kFILEREFERENCE = "gs://realtimechatfirabase.appspot.com/"


//MARK: uploadImage

func uploadImage(image: UIImage, chatRoomId: String, view: UIView, completion: @escaping (_ imageLink: String?) -> Void) {
    
    let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
    
    progressHUD.mode = .determinateHorizontalBar
    
    let dateString = dateFormatter().string(from: Date())
    
    let photoFileName = "PictureMessages/" + FUser.currentId() + "/" + chatRoomId + "/" + dateString + ".jpg"
    
    let storageRef = storage.reference(forURL: kFILEREFERENCE).child(photoFileName)
    
    let imageData = image.jpegData(compressionQuality: 0.4)
    
    var task : StorageUploadTask!
    
    task = storageRef.putData(imageData!, metadata: nil, completion: { (metadata, error) in
        
        task.removeAllObservers()
        progressHUD.hide(animated: true)
        
        if error != nil {
            print("error uploading image \(error!.localizedDescription)")
            return
        }
        
        storageRef.downloadURL { (url, error) in
            
            guard let imageURL = url else{
                completion(nil)
                return
            }
            
            completion(imageURL.absoluteString)
        }
        
    })
    
    task.observe(StorageTaskStatus.progress) { (snapshot) in
        
        progressHUD.progress = Float((snapshot.progress?.completedUnitCount)!) / Float((snapshot.progress?.totalUnitCount)!)
    }

}

//MARK: downloadImage
func downloadImage(imageUrl: String, completion: @escaping(_ image: UIImage?) -> Void) {
    
    let imageURL = NSURL(string: imageUrl)
    
    let imageFileName = (imageUrl.components(separatedBy: "%").last!).components(separatedBy: "?").first!

    
    if fileExistsAtPath(path: imageFileName) {
        
        //exist
        if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(fileName: imageFileName)) {
            completion(contentsOfFile)
        } else {
            print("couldnt generate image")
            completion(nil)
        }
        
    } else {
        //doesnt exist
        
        let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
        
        downloadQueue.async {
            
            let data = NSData(contentsOf: imageURL! as URL)
            
            if data != nil {
                
                var fileManagerURL = getDocumentsURL()
                // to save image locally and then return it
                fileManagerURL = fileManagerURL.appendingPathComponent(imageFileName, isDirectory: false)
                
                data!.write(to: fileManagerURL, atomically: true)
                
                let imageToReturn = UIImage(data: data! as Data)
                
                DispatchQueue.main.async {
                    completion(imageToReturn!)
                }
                
            } else {
                DispatchQueue.main.async {
                    print("no image in database")
                    completion(nil)
                }
            }
        }
    }
}


//MARK: File Path and if Exist at Documents

func getDocumentsURL() -> URL {
    
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    
    return documentURL!
}

//"file/last/\(filename)"
func fileInDocumentsDirectory(fileName: String) -> String {
    
    let fileURL = getDocumentsURL().appendingPathComponent(fileName)
    return fileURL.path
}


func fileExistsAtPath(path: String) -> Bool {
    
    var doesExist = false
    
    let filePath = fileInDocumentsDirectory(fileName: path)
    let fileManager = FileManager.default
    
    if fileManager.fileExists(atPath: filePath) {
        doesExist = true
    }else {
        doesExist = false
    }
    
    return doesExist
}
