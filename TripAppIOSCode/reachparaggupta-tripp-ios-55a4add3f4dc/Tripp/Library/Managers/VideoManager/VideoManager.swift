//
//  VideoManager.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit
import UIKit
import AWSS3

class VideoManager {
    
    class func thumbnail(for path: String, handler: @escaping (_ image: UIImage?) -> Void) {
        guard let url = URL(string: path) else{
            handler(nil)
            return
        }
        
        AWSTMCache.shared().object(forKey: path, block: { (chache, imageName, object) in
            if object != nil {
                let image = object as? UIImage
                handler(image)
            }
            else {
                Utils.createBackGroundQueue {
                    fetchThumbnail(url: url, path: path, handler: handler)
                }
            }
        })
    }
    class func fetchThumbnail(url: URL, path: String, handler: @escaping (_ image: UIImage?) -> Void){
        do {
            let asset = AVURLAsset(url: url , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            AWSTMCache.shared().setObject(thumbnail, forKey: path, block: { (chache, imageName, object) in
                handler(thumbnail)
            })
        }
        catch _ {
            handler(nil)
        }
    }
    class func playVideoWithUrl(viewController: UIViewController, url: String)
    {
        let videoURL = URL(string: url)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        viewController.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }

}
