//
//  MediaViewerViewController.swift
//  Tripp
//
//  Created by Monu on 17/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

enum MediaMode {
    case viewer
    case addMedia
}

typealias SaveAssetMediaCompletion = (_ asset: MediaAsset?) -> ()

class MediaViewerViewController: UIViewController {

    @IBOutlet weak var titleCountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var assets:[MediaAsset] = []
    var selectedItem:Int?
    var mediaMode: MediaMode = .viewer
    var saveAssetHandler: SaveAssetMediaCompletion?
    
    //MARK: UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    //MARK: Private Methods
    private func setupView(){
        self.titleCountLabel.layer.cornerRadius = 13.5
        self.titleCountLabel.layer.borderColor = UIColor.white.cgColor
        self.titleCountLabel.layer.borderWidth = 1.0
        self.perform(#selector(MediaViewerViewController.setSelectedIndex), with: nil, afterDelay: 0.1)
    }
    
    @objc func setSelectedIndex(){
        if let item = self.selectedItem{
            self.titleCountLabel.text = "\(item+1)/\(assets.count)"
            self.collectionView.scrollToItem(at: IndexPath(item: item, section: 0), at: .left, animated: false)
        }
        else{
            self.titleCountLabel.text = "1/\(assets.count)"
        }
    }
    
    //MARK: IBAction methods
    
    @IBAction func saveMediaButtonTapped(_ sender: UIButton) {
        let asset = self.assets[sender.tag]
        self.uploadMediaAssetOnAWS(media: asset)
    }
    
    //MARK: Upload Media on AWS Server
    private func uploadMediaAssetOnAWS(media: MediaAsset){
        if media.mediaType == .photo {
            self.uploadMediaPhoto(media: media)
        }
        else{
            self.uploadMediaVideo(media: media)
        }
    }
    
    private func uploadMediaVideo(media: MediaAsset){
        AppLoader.showLoader()
        Utils.uploadVideoOnS3(videoUrl: media.localVideoUrl, type: .media) { (fileName, errorMessage) in
            AppLoader.hideLoader()
            if let imageName = fileName{
                media.isSaveMedia = true
                media.imageURL = imageName
                self.collectionView.reloadData()
                if let handler = self.saveAssetHandler{
                    handler(media)
                }
            }else{
                AppToast.showErrorMessage(message: errorMessage!)
            }
        }
    }
    
    private func uploadMediaPhoto(media: MediaAsset){
        AppLoader.showLoader()
        Utils.uploadImageOnSS3(image: media.image!, type: .media) { (name, error) in
            AppLoader.hideLoader()
            if let imageName = name{
                media.isSaveMedia = true
                media.imageURL = imageName
                self.collectionView.reloadData()
                if let handler = self.saveAssetHandler{
                    handler(media)
                }
            }else{
                AppToast.showErrorMessage(message: error!)
            }
        }
    }
}


class MediaAsset {
    
    var imageURL: String = ""
    var caption: String = ""
    var mediaType: MediaType = .photo
    var isSaveMedia = true
    var image: UIImage?
    var localVideoUrl = ""
    var assetBucketIndex = 0
    var address: String?
    var city: String?
    var state: String?
    var country: String?
    var latitude: String?
    var longitude: String?
    
    func addAddress(address: String?, city:String?, state:String?, county:String?){
        self.address = address
        self.city = city
        self.state = state
        self.country = county
    }
    
    func updateLatLong(latitude:String?, longitude:String?){
        self.latitude = latitude
        self.longitude = longitude
    }
}
