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
    var photoData: [PhotoElementData] = []
    
    private let networkManager = NetworkManager.shared
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainVC()
        
        configureCollectionView()
        loadData()
    }
    
    // MARK: - Configure
    
    func configureMainVC() {
        self.title = "Lorem pictures";
        
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
    
    // MARK: - Major methods
    
    private func loadData(completion: (() -> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            self?.networkManager.loadPhotos() { [weak self] result in
                
                switch result {
                case let .success(photoElements):
                    let photoData: [PhotoElementData] = photoElements.map {  PhotoElementData(photoElement: $0)}
                    DispatchQueue.main.async { [weak self] in
                        self?.photoData.removeAll()
                        //self?.photoData = photoData.map{$0}
                        self?.photoData = photoData
                        self?.collectionView.reloadData()
                        completion?()
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

