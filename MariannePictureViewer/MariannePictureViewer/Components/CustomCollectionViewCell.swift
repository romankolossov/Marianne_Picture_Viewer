//
//  CustomCollectionViewCell.swift
//  MariannePictureViewer
//
//  Created by Roman Kolosov on 13.02.2021.
//

import UIKit
import SDWebImage

class CustomCollectionViewCell: UICollectionViewCell {
    
    // Some properties
    var pictureLabel: UILabel = UILabel()
    var pictureImageView: UIImageView = UIImageView()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    private func configureCell() {
        self.backgroundColor = .clear
        
        let pictureLabelFrame = CGRect(x: 3.0, y: 3.0, width: self.bounds.size.width - 6, height: 12.0)
        self.pictureLabel = UILabel(frame: pictureLabelFrame)
        self.pictureLabel.font = .systemFont(ofSize: 12)
        self.pictureLabel.textColor = .purple
        self.pictureLabel.textAlignment = NSTextAlignment.center
        self.pictureLabel.alpha = 0
        
        self.contentView.addSubview(self.pictureLabel)
        
        let pictureImageViewFrame = CGRect(x: 0.0, y: 3.0 + pictureLabel.frame.height + 3.0 , width: self.bounds.size.width, height: 78.0)
        self.pictureImageView = UIImageView(frame: pictureImageViewFrame)
        self.pictureImageView.contentMode = .scaleAspectFit
        self.pictureImageView.alpha = 0
        
        self.contentView.addSubview(pictureImageView)
    }
    
    func lookConfigure(with photo: PhotoElementData, photoService: CollectionViewPhotoService?, indexPath: IndexPath) {
        
        guard let photoStringURL = photo.downloadURL else {
            fatalError()
        }
        self.pictureLabel.text = photo.author
        
        // SDWebImage used since it is the most easy way to download images avoiding its mismatch in cells
        self.pictureImageView.sd_setImage(with: URL(string: photoStringURL)) { [self] (image, error, SDImageCacheType, url) in
            
            self.animateSubviews()
        }
        
        // Way of use image caches
        //self.pictureImageView.image = photoService?.getPhoto(atIndexPath: indexPath, byUrl: photoStringURL)
        
        animate()
    }
    
    // MARK: - Animations
    
    private func animate() {
        UIView.animate(withDuration: 2.1,
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        self.backgroundColor = .brown
                       },
                       completion: nil)
    }
    
    private func animateSubviews() {
        UIView.transition(with: self.pictureLabel,
                          duration: 1.2,
                          options: [.transitionFlipFromTop, .curveEaseInOut],
                          animations: {
                            self.pictureLabel.alpha = 1
                          },
                          completion: nil)
        
        UIView.transition(with: self.pictureImageView,
                          duration: 1.2,
                          options: [.transitionCrossDissolve, .curveEaseInOut],
                          animations: {
                            self.pictureImageView.alpha = 1
                          },
                          completion: nil)
    }
}
