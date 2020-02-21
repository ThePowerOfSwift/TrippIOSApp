//
//  AlbumLayout.swift
//  Tripp
//
//  Created by Monu on 13/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AlbumLayoutAttribute: UICollectionViewLayoutAttributes {
    
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    var angle: CGFloat = 0 {
        didSet {
            zIndex = Int(angle * 1000000)
            transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    override func copy(with zone: NSZone? = nil) -> Any{
        let copiedAttributes: AlbumLayoutAttribute = super.copy(with: zone) as! AlbumLayoutAttribute
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        return copiedAttributes
    }
}

class AlbumLayout: UICollectionViewLayout {
    
    let itemSize = CGSize(width: 250, height: 184)
    
    //let centerSpace = (UIScreen.main.bounds.width / 2) - 70
    
    var x: CGFloat = 0.0
    
    var margin: CGFloat = 7.7
    
    var currentCenter: CGFloat = 0.0
    
    let screenCenterX = (UIScreen.main.bounds.width / 2)
    
    var attributesList = [AlbumLayoutAttribute]()
    
    override var collectionViewContentSize: CGSize {
        let width = (CGFloat((collectionView?.numberOfItems(inSection: 0))!) * (itemSize.width+margin)) + (Global.screenRect.size.width - 269) + 8
        return CGSize(width: width, height: (collectionView?.bounds.height)!)
    }
    
    override class var layoutAttributesClass: AnyClass {
        return AlbumLayoutAttribute.self
    }
    
    override func prepare() {
        super.prepare()
        x = (Global.screenRect.size.width - 269) / 2
        attributesList = (0..<(collectionView?.numberOfItems(inSection: 0))!).map{ (i) -> AlbumLayoutAttribute in
            let attributes = AlbumLayoutAttribute(forCellWith: IndexPath(row: i, section: 0))
            
            attributes.size = self.itemSize
            attributes.frame.origin.x = x
            
            let center = (collectionView?.contentOffset.x)! + self.screenCenterX
            let distanceFromCenter = center - attributes.center.x
            
            var alphaValue = CGFloat(0.45)
            if(distanceFromCenter > 0){
                alphaValue = CGFloat(1.0) - (distanceFromCenter / self.screenCenterX)
            }
            else{
                alphaValue = CGFloat(1.0) - (distanceFromCenter * -1) / self.screenCenterX
            }
            
            if alphaValue < 0.45 {
                alphaValue = CGFloat(0.45)
            }
            
            attributes.alpha = alphaValue
            
            attributes.center = CGPoint(x: attributes.center.x, y: self.itemSize.height / 2)
            x = x + self.itemSize.width + margin
            return attributes
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesList[indexPath.row]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
