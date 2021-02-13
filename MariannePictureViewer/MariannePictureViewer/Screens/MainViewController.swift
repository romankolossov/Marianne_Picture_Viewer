//
//  MainViewController.swift
//  MariannePictureViewer
//
//  Created by Roman Kolosov on 12.02.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    // Some properties
    let cellIdentifier : String = "CellIdentifier"
    var collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainVC()
        
        configureCollectionView()
    }
    
    // MARK: - Configure
    
    func configureMainVC() {
        self.title = "Pictures";
        
        self.navigationController?.navigationBar.prefersLargeTitles = true;
    }
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        layout.itemSize = CGSize(width: 100.0, height: 100.0)
        layout.scrollDirection = .vertical
        
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.collectionView.backgroundColor = .lightGray
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        self.view.addSubview(self.collectionView)
    }
}

