//
//  AWSImagesmanager.swift
//  Tripp
//
//  Created by Bharat Lal on 18/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import AWSS3
typealias cashedImageName = (_ imageName: String?, _ image: Any?) -> Void
typealias S3ImageUploadCompletionHandler = (_ success: Bool) -> Void
typealias S3ImageDownloadCompletionHandler = (_ success: Bool, _ image: UIImage?) -> Void
typealias S3FileDownloadCompletionHandler = (_ success: Bool, _ fileUrl: URL?) -> Void
typealias S3ImageDeleteCompletionHandler = (_ success: Bool) -> Void
public typealias imageCloser = ((_ image : UIImage?) -> Void)

enum FileType: String{
    case profile = "profile/"
    case media = "media/"
    case liveTrip = "LiveTrip/"
    case group = "group/"
    case logs = "logs/"
}

class AWSImageManager {
    
     static let sharedManger = AWSImageManager()
     var uploadRequests = Array<AWSS3TransferManagerUploadRequest?>()
     var uploadFileURLs = Array<NSURL?>()
    
     var uploadCompletionHandler: S3ImageUploadCompletionHandler?
     var downloadCompletionHandler: S3ImageDownloadCompletionHandler?
     var deleteCompletionHandler: S3ImageDeleteCompletionHandler?
    
    class func configureAWS(){
        // Initialize the Amazon Cognito credentials provider
        let poolId = ConfigurationManager.shared.s3IdentityPoolId()
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.usEast1,
                                                                identityPoolId:poolId)
        let configuration = AWSServiceConfiguration(region:.usEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        //AWSLogger.default().logLevel = .verbose
    }
    
    func uploadLogFileToS3() {
        let userId = AppUser.currentUser().userId.description
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileName = "Logger.txt"
            let logFileUrl = dir.appendingPathComponent(fileName)
            let fileUrl = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("tempSave")
            let videoData = NSData(contentsOf: URL(string: logFileUrl.absoluteString)!)
            let fileManager = FileManager.default
            fileManager.createFile(atPath: (fileUrl?.path)! as String, contents: videoData! as Data, attributes: nil)
            
            let formatter = DateFormatter()
            formatter.dateFormat = AppDateFormat.UTCFormat
            let logFilePathForS3 = FileType.logs.rawValue + userId + "/" + formatter.string(from: Date()) + ".txt"
            //self.uploadFileOnS3(atPath: fileUrl!, name: logFilePathForS3, contentType: "text/plain", handler: handler)
            
            self.uploadFileOnS3(atPath: fileUrl!, name: logFilePathForS3, contentType: "text/plain") { (status) in
                if status == true {
                    do {
                        try FileManager.default.removeItem(at: logFileUrl)
                    } catch {
                        print(error)
                    }
                }
            }
            
        }
    }
    
    func uploadVideoToS3(videoUrl: String, fileName: String, handler: S3ImageUploadCompletionHandler?){
        self.uploadCompletionHandler = handler
        let fileUrl = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("tempSave")
        let videoData = NSData(contentsOf: URL(string: videoUrl)!)
        let fileManager = FileManager.default
        fileManager.createFile(atPath: (fileUrl?.path)! as String, contents: videoData! as Data, attributes: nil)
        self.uploadFileOnS3(atPath: fileUrl!, name: fileName, contentType: "video/mp4", handler: handler)
    }
    
    func uploadImagetoS3(image : UIImage, imageName: String, type: FileType, handler: S3ImageUploadCompletionHandler?)  {
        self.uploadCompletionHandler = handler
        let fileUrl = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("tempSave")
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        let fileManager = FileManager.default
        fileManager.createFile(atPath: (fileUrl?.path)! as String, contents: imageData, attributes: nil)
        
        var name = ""
        switch type {
        case .profile:
            name =  FileType.profile.rawValue + imageName
        default:
            name = imageName
        }
        
        self.uploadFileOnS3(atPath: fileUrl!, name: name, contentType: "image/jpeg", handler: handler)
    }
    
    func uploadFileOnS3(atPath: URL, name: String, contentType: String, handler: S3ImageUploadCompletionHandler?){
        self.uploadCompletionHandler = handler
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.body = atPath
        uploadRequest?.key = name
        uploadRequest?.bucket = ConfigurationManager.shared.s3Bucketname()
        uploadRequest?.contentType = contentType
        uploadRequest?.acl = AWSS3ObjectCannedACL.publicRead
        uploadRequest?.serverSideEncryption = AWSS3ServerSideEncryption.unknown
        uploadRequests.append(uploadRequest)
        uploadFileURLs.append(nil)
        uploadImage(uploadRequest!)
    }
    
     func uploadImage(_ uploadRequest: AWSS3TransferManagerUploadRequest) {
        let transferManager = AWSS3TransferManager.default()

        transferManager?.upload(uploadRequest).continue({ (task) -> Any? in
            if let _ = task.error {
                self.uploadCompletedWithoutError(false)
            }
            if let _ = task.exception {
                self.uploadCompletedWithoutError(false)
            }

            if task.result != nil {
                if let index = self.indexOfUploadRequest(self.uploadRequests, uploadRequest: uploadRequest) {
                    self.uploadRequests[index] = nil
                    self.uploadFileURLs[index] = uploadRequest.body as NSURL?
                }
                self.uploadCompletedWithoutError(true)
                
            }
            return nil
        })
    }
    
    func uploadCompletedWithoutError(_ success: Bool){
       // DispatchQueue.global(qos: .userInitiated).async { // 1
            if self.uploadCompletionHandler != nil {
                self.uploadCompletionHandler!(success)
            }
       // }
    }
    
    func indexOfUploadRequest(_ array: Array<AWSS3TransferManagerUploadRequest?>, uploadRequest: AWSS3TransferManagerUploadRequest?) -> Int? {
            for (index, object) in array.enumerated() {
                if object == uploadRequest {
                    return index
                }
            }
            return nil
    }
    
    func newFileName(_ folderName : String, fileExtension: String = ".jpg") -> String {
        let timeStamp = Int64(NSDate().timeIntervalSince1970)
        let timeStampStr = String(format: "%d", timeStamp)
        let randomString = self.generateRandomString()
        let bucketFileName = folderName + String(timeStampStr.characters.reversed()) + "-" + randomString + fileExtension
        return bucketFileName
    }
    
    private func generateRandomString() -> String {
        let randomNum:UInt32 = arc4random_uniform(100)
        let randomString:String = String(randomNum)
        return randomString
    }
    
    func downloadFileFromS3(_ name: String, completion:@escaping S3FileDownloadCompletionHandler){
        let fileUrl = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
        let downloadRequest:AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest.bucket = ConfigurationManager.shared.s3Bucketname()
        downloadRequest.key = FileType.liveTrip.rawValue + name
        downloadRequest.downloadingFileURL = fileUrl
        let transferManager = AWSS3TransferManager.default()
        transferManager?.download(downloadRequest).continue({ (task) -> Any? in
            if task.error != nil {
                completion(false,nil)
            }
            else {
                completion(true, fileUrl)
            }
            return nil
        })
    }
    
    func downloadImage(_ imageName: String, completion:@escaping S3ImageDownloadCompletionHandler) {
        self.downloadCompletionHandler = completion
        let fileUrl = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("imageName")
        let downloadRequest:AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
        
        downloadRequest.bucket = ConfigurationManager.shared.s3Bucketname()
        downloadRequest.key = imageName
        downloadRequest.downloadingFileURL = fileUrl
        
        let transferManager = AWSS3TransferManager.default()
        
        transferManager?.download(downloadRequest).continue({ (task) -> Any? in
            if task.error != nil {
                completion(false,nil)
            }
            else {
                DispatchQueue.global().async {
                    
                    if downloadRequest.key != nil {
                        self.fetchImageAndSaveToCacheFromUrl(fileUrl: fileUrl, downloadRequest: downloadRequest, completion: completion)
                    }
                }
            }
            
            return nil
        })
    
    }
    func fetchImageAndSaveToCacheFromUrl(fileUrl: URL?, downloadRequest: AWSS3TransferManagerDownloadRequest, completion: @escaping S3ImageDownloadCompletionHandler){
        let image = UIImage(contentsOfFile: (fileUrl?.path)!)
        if image != nil {
            self.saveImageToLocalCache(image!, folderName:nil,saveImageName: downloadRequest.key! ,compeletion: { (name, imageC) in
                if (name?.isEmpty)! {
                    AppToast.showErrorMessage(message: "Error in downloding image")
                }
            })
        }
        else {
            DLog(message: "fileUrl?.path, \(String(describing: fileUrl?.path))" as AnyObject)
        }
        DispatchQueue.main.async {
            completion(true,image)
        }
    }
    func imageWithName(_ imageName : String,completion:@escaping S3ImageDownloadCompletionHandler) {
        AWSTMCache.shared().object(forKey: imageName, block: { (chache, imageName, object) in
            if object != nil {
                DispatchQueue.main.async {
                    let image = object as? UIImage
                    completion(true, image)
                }
            }
            else {
                self.downloadImage(imageName!, completion: completion)
            }
        })
    }

    func deleteImageFromS3(imageName : String, completion: S3ImageDeleteCompletionHandler?) {
         self.deleteCompletionHandler = completion
        let deleteRequest:AWSS3DeleteObjectRequest = AWSS3DeleteObjectRequest()
        
        deleteRequest.bucket = ConfigurationManager.shared.s3Bucketname()
        deleteRequest.key = imageName
        
        AWSS3.default().deleteObject(deleteRequest) { (AWSS3DeleteObjectOutput, error) in
            if error != nil {
                self.deleteCompletionHandler!(false)
            }else{
               self.deleteCompletionHandler!(true)
            }
        }
    }
    
    func saveImageToLocalCache(_ image : UIImage,folderName:FileType?,saveImageName : String?,compeletion : @escaping cashedImageName) {
        var imageName = ""
        if folderName != nil {
            imageName = self.newFileName(folderName!.rawValue)
        }
        else {
            imageName = saveImageName!
        }
        AWSTMCache.shared().setObject(image, forKey: imageName, block: { (chache, imageName, object) in
            if object == nil {
                compeletion(nil, nil)
            }else {
                compeletion(imageName, object as! UIImage)
            }
        })
     }
     
}
