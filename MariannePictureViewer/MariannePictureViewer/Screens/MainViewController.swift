//
//  MainViewController.swift
//  MariannePictureViewer
//
//  Created by Roman Kolosov on 12.02.2021.
//

import UIKit

class MainViewController: BaseViewController {
    
    // Some properties
    private let cellIdentifier: String = "CellIdentifier"
    var publicCellIdentifier: String {
        cellIdentifier
    }
    private var collectionViewPhotoService: CollectionViewPhotoService?
    var publicCollectionViewPhotoService: CollectionViewPhotoService? {
        collectionViewPhotoService
    }
    private let networkManager = NetworkManager.shared
    
    private var collectionView: UICollectionView!
    
    var photoData: [PhotoElementData] = []
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainVC()
        
        configureCollectionView()
        collectionViewPhotoService = CollectionViewPhotoService(container: collectionView)
        
        loadData()
    }
    
    // MARK: - Configure
    
    private func configureMainVC() {
        self.title = "Lorem pictures";
        
        self.navigationController?.navigationBar.prefersLargeTitles = true;
    }
    
    private func configureCollectionView() {
        // Custom layout
        let layout = PhotoLayout()
        
        // Regular layout configuration
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 10.0
//        layout.minimumInteritemSpacing = 10.0
//        layout.itemSize = CGSize(width: 100.0, height: 100.0)
//        layout.scrollDirection = .vertical
        
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.collectionView.backgroundColor = .lightGray
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: publicCellIdentifier)
        
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
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
}

