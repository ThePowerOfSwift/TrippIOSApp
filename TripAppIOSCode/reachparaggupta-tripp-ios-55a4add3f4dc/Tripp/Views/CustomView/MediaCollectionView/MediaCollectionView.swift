//
//  MediaCollectionView.swift
//  Tripp
//
//  Created by Monu on 17/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import RealmSwift


class MediaCollectionView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var waypointMedia = List<WaypointMedia>()
    
    var mediaMode: MediaMode = .viewer
        
    //MARK: Initialize filter view
    class func initializeMedia() -> MediaCollectionView{
        let media = MediaCollectionView.fromNib()
        media.setupView()
        return media
    }
    
    //MARK: Helper
    class func fromNib<T : MediaCollectionView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }

    //MARK: Private Methods
    private func setupView(){
        initializeCollectionView()
    }
    
    private func initializeCollectionView(){
        self.collectionView.register(UINib(nibName: MediaCollectionCell.itemIdentifier, bundle: nil), forCellWithReuseIdentifier: MediaCollectionCell.itemIdentifier)
    }
    
    
    
}
