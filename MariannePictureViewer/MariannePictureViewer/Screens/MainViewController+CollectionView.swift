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
        21
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CustomCollectionViewCell
        
        cell.pictureLabel.text = "Hello, Picture!"
        cell.pictureImageView.image = UIImage(named: "FerrariTestPicture")
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Hello")
        let secondVC = SecondViewController()
        
        secondVC.pictureLabel.text = "Hello, Second!";
        secondVC.pictureImageView.image = UIImage(named: "FerrariTestPicture")
        
        self.navigationController?.show(secondVC, sender: self)
    }
}
