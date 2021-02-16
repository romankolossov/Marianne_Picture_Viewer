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
        let photoElementData = self.photoData[indexPath.row]
        
        cell.lookConfigure(with: photoElementData,
                           photoService: publicCollectionViewPhotoService,
                           indexPath: indexPath)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let secondVC = SecondViewController()
        
        let photoElementData = self.photoData[indexPath.row]
        
        secondVC.lookConfigure(with: photoElementData,
                           photoService: publicCollectionViewPhotoService,
                           indexPath: indexPath)
        
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
}
