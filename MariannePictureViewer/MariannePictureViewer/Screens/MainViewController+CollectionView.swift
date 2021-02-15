//
//  MainViewController+CollectionView.swift
//  MariannePictureViewer
//
//  Created by Roman Kolosov on 13.02.2021.
//

import UIKit

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource protocol methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.photoData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: publicCellIdentifier, for: indexPath) as? CustomCollectionViewCell else {
            fatalError()
        }
        let stringPhotoImageURL = self.photoData[indexPath.row].downloadURL
        
        // SDWebImage used since it is the most easy way to download images avoiding its mismatch in cells
        cell.pictureImageView.sd_setImage(with: URL(string: stringPhotoImageURL ?? "")) { (image, error, SDImageCacheType, url) in
            cell.pictureLabel.text = self.photoData[indexPath.row].author
            
            cell.animateSubviews()
        }
        cell.animate()
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Hello")
        let secondVC = SecondViewController()
        
        secondVC.pictureLabel.text = self.photoData[indexPath.row].author
        let stringPhotoImageURL = self.photoData[indexPath.row].downloadURL
        
        secondVC.pictureImageView.sd_setImage(with: URL(string: stringPhotoImageURL ?? ""), completed: nil)
        
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
}
