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
    var publicNetworkManager: NetworkManager {
        networkManager
    }
    private var collectionView: UICollectionView!
    private var refreshControl: UIRefreshControl?
    var photoData: [PhotoElementData] = []
    var isLoading: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        
        configureMainVC()
        configureCollectionView()
        
        setupRefreshControl()
        collectionViewPhotoService = CollectionViewPhotoService(container: collectionView)
        
        loadData()
    }
    
    // MARK: - Configure
    
    private func configureMainVC() {
        self.title = localize("mainVCName")
        
        self.navigationController?.navigationBar.prefersLargeTitles = true;
    }
    
    private func configureCollectionView() {
        // Custom layout
        let layout = PhotoLayout()
        
        /* // Regular layout configuration
         let layout = UICollectionViewFlowLayout()
         layout.minimumLineSpacing = 10.0
         layout.minimumInteritemSpacing = 10.0
         layout.itemSize = CGSize(width: 100.0, height: 100.0)
         layout.scrollDirection = .vertical
         */
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.collectionView.backgroundColor = .lightGray
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.prefetchDataSource = self
        
        self.collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: publicCellIdentifier)
        
        self.view.addSubview(self.collectionView)
    }
    
    // MARK: Pull-to-refresh pattern method
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        
        refreshControl?.attributedTitle = NSAttributedString(string: localize("reloadData"), attributes: [.font : UIFont.systemFont(ofSize: 12)])
        refreshControl?.tintColor = .systemOrange
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        collectionView.refreshControl = refreshControl
    }
    
    // MARK: - Network methods
    
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
                        self?.isLoading = false
                        completion?()
                    }
                case let .failure(error):
                    self?.showAlert(title: self?.localize("error"), message: error.localizedDescription)
                }
            }
        }
    }
    
    func loadPartData(from page: Int, completion: (() -> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            self?.networkManager.loadPartPhotos(from: page) { [weak self] result in
                
                switch result {
                case let .success(photoElements):
                    let photoData: [PhotoElementData] = photoElements.map {  PhotoElementData(photoElement: $0)}
                    DispatchQueue.main.async { [weak self] in
                        self?.photoData = (self?.photoData ?? []) + photoData
                        self?.collectionView.reloadData()
                        self?.isLoading = false
                        completion?()
                    }
                case let .failure(error):
                    self?.showAlert(title: self?.localize("error"), message: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        self.loadData { [weak self] in
            self?.refreshControl?.endRefreshing()
        }
    }
}

