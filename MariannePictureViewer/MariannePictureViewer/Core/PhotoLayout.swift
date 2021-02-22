//
//  PhotoLayout.swift
//  MariannePictureViewer
//
//  Created by Roman Kolosov on 16.02.2021.
//

import UIKit

class PhotoLayout: UICollectionViewLayout {
    let cellHeight: CGFloat = 168
    
    let columnsCount = 1
    var totalCellHeight: CGFloat = 0
    
    var cachedAttributes = [IndexPath : UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        self.cachedAttributes = [:]
        
        guard let collectionView = self.collectionView else { return }
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        guard itemsCount > 0 else { return }
        
        let bigCellWidth = collectionView.bounds.size.width
        let smallCellWidth = ceil(collectionView.bounds.size.width / CGFloat(self.columnsCount))
        
        var lastX: CGFloat = 0
        var lastY: CGFloat = 0
        
        for index in 0..<itemsCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let isBigCell = (index + 1 ) % (self.columnsCount + 1) == 0
            
            if isBigCell {
                attributes.frame = CGRect(x: 0, y: lastY,
                                          width: bigCellWidth,
                                          height: self.cellHeight)
                lastY += self.cellHeight
            } else {
                attributes.frame = CGRect(x: lastX, y: lastY,
                                          width: smallCellWidth,
                                          height: self.cellHeight)
                
                let isLastColumn = (index + 2) % (self.columnsCount + 1) == 0 ||
                    index == itemsCount - 1
                
                if isLastColumn {
                    lastX = 0
                    lastY += self.cellHeight
                } else {
                    lastX += smallCellWidth
                }
            }
            cachedAttributes[indexPath] = attributes
        }
        self.totalCellHeight = lastY
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes.values.filter{ atributes in
            return rect.intersects(atributes.frame)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath]
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.collectionView?.bounds.size.width ?? 0, height: self.totalCellHeight)
    }
}

