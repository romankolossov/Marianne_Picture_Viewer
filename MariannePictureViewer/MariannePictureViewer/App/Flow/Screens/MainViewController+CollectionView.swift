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
        guard let photos = self.photos else { fatalError(description) }

        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: publicCellIdentifier, for: indexPath) as? CustomCollectionViewCell else { fatalError(description) }
        guard let photos = self.photos else { fatalError(description) }

        let photoElementData = photos[indexPath.row]

        cell.lookConfigure(with: photoElementData,
                           photoService: publicCollectionViewPhotoService,
                           indexPath: indexPath)

        return cell
    }

    // MARK: - UICollectionViewDelegate protocol methods

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photos = self.photos else { return }
        let secondVC = SecondViewController()

        let photoElementData = photos[indexPath.row]

        secondVC.lookConfigure(with: photoElementData,
                           photoService: publicCollectionViewPhotoService,
                           indexPath: indexPath)

        self.navigationController?.pushViewController(secondVC, animated: true)
    }
}

// MARK: - Infinite Scrolling pattern methods

extension MainViewController: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let photos = self.photos else { return }
        guard let maxIndex = indexPaths.map({ $0.row }).max() else { return }

        if (maxIndex > photos.count - 3), !isLoading {
            self.isLoading = true
            self.loadPartData(from: NetworkManager.shared.nextFromPage)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    }
}
