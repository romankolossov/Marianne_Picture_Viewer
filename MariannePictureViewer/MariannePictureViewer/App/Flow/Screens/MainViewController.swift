//
//  MainViewController.swift
//  MariannePictureViewer
//
//  Created by Roman Kolosov on 12.02.2021.
//

import UIKit
import RealmSwift

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
    private let realmManager = RealmManager.shared

    var photos: Results<PhotoElementData>? {
        let photos: Results<PhotoElementData>? = realmManager?.getObjects()
        return photos?.sorted(byKeyPath: "id", ascending: true)
    }
    private var collectionView: UICollectionView?
    private var refreshControl: UIRefreshControl?
    var isLoading: Bool = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as? AppDelegate)?.restrictRotation = .portrait

        configureMainVC()
        configureCollectionView()

        setupRefreshControl()
        collectionViewPhotoService = CollectionViewPhotoService(container: collectionView)

        if let photos = photos, photos.isEmpty {
            loadData()
        }
    }

    // MARK: - Configure

    private func configureMainVC() {
        self.title = localize("mainVCName")

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureCollectionView() {
        // Custom layout
        let layout = PhotoLayout()

        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView?.backgroundColor = .lightGray

        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.prefetchDataSource = self

        collectionView?.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: publicCellIdentifier)

        guard let collectionSubview = collectionView else {
            return
        }
        self.view.addSubview(collectionSubview)
    }

    // MARK: Pull-to-refresh pattern method

    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()

        refreshControl?.attributedTitle = NSAttributedString(string: localize("reloadData"), attributes: [.font: UIFont.systemFont(ofSize: 12)])
        refreshControl?.tintColor = .systemOrange
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)

        collectionView?.refreshControl = refreshControl
    }

    // MARK: - Network methods

    private func loadData(completion: (() -> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            self?.networkManager.loadPhotos { [weak self] result in

                switch result {
                case let .success(photoElements):
                    let photos: [PhotoElementData] = photoElements.map { PhotoElementData(photoElement: $0) }
                    DispatchQueue.main.async { [weak self] in
                        try? self?.realmManager?.deleteAll()
                        try? self?.realmManager?.add(objects: photos)
                        self?.collectionView?.reloadData()
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
                    let nextPhotos: [PhotoElementData] = photoElements.map { PhotoElementData(photoElement: $0) }
                    DispatchQueue.main.async { [weak self] in
                        try? self?.realmManager?.add(objects: nextPhotos)
                        self?.collectionView?.reloadData()
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
        NetworkManager.shared.nextFromPage = 2
        self.loadData { [weak self] in
            self?.refreshControl?.endRefreshing()
        }
    }
}
