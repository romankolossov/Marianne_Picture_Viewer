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
    private var cachedImages = [String : UIImage]()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure methods
    
    private func configureCell() {
        let indent: CGFloat = 3.0
        
        self.contentView.alpha = 0
        self.backgroundColor = .systemYellow
        
        let pictureLabelFrame = CGRect(x: indent, y: indent,
                                       width: self.bounds.size.width - indent * 2,
                                       height: 26.0)
        
        self.pictureLabel = UILabel(frame: pictureLabelFrame)
        self.pictureLabel.font = .systemFont(ofSize: 12)
        self.pictureLabel.textColor = .purple
        self.pictureLabel.textAlignment = NSTextAlignment.center
        
        self.contentView.addSubview(self.pictureLabel)
        
        let pictureImageViewFrame = CGRect(x: self.bounds.size.width / 2 - (self.bounds.size.height - pictureLabel.frame.height) * 16 / 9 / 2,
                                           y: indent + pictureLabel.frame.height,
                                           width: (self.bounds.size.height - pictureLabel.frame.height) * 16 / 9,
                                           height: self.bounds.size.height - pictureLabel.frame.height)
        
        self.pictureImageView = UIImageView(frame: pictureImageViewFrame)
        self.pictureImageView.contentMode = .scaleAspectFit
        
        self.contentView.addSubview(pictureImageView)
    }
    
    func lookConfigure(with photo: PhotoElementData, photoService: CollectionViewPhotoService?, indexPath: IndexPath) {
        
        guard let photoStringURL = photo.downloadURL else {
            fatalError()
        }
        self.pictureLabel.text = photo.author
        
        // SDWebImage used since it is the most easy way to download images avoiding its mismatch in cells. Also it shows the download activity
        self.pictureImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        // Cache use
        if let photo = cachedImages[photoStringURL] {
            self.pictureImageView.image = photo
            
            print("\(photoStringURL) : Cached image")
        } else {
            self.pictureImageView.sd_setImage(with: URL(string: photoStringURL)) { [self] (image, error, SDImageCacheType, url) in
                guard let image = image else { return }
                
                DispatchQueue.main.async { [weak self] in
                    self?.cachedImages[photoStringURL] = image
                }
                self.animateSubviews()
                print("\(photoStringURL) : Network image")
            }
        }
        animate()
        animateSubviews()
        
        // Way of use image caches. It is slower than the use SDWebImage for network
        // Also causes mismatch images when cache fomm file used
        // Stack - CollectionViewPhotoService
        //self.pictureImageView.image = photoService?.getPhoto(atIndexPath: indexPath, byUrl: photoStringURL)
    }
    
    // MARK: - Animations
    
    private func animate() {
        UIView.transition(with: self.contentView,
                          duration: 1.2,
                          options: [.transitionCrossDissolve, .curveEaseInOut],
                          animations: {
                            self.backgroundColor = .brown
                            self.contentView.alpha = 1
                          },
                          completion: nil)
    }
    
    private func animateSubviews() {
        UIView.transition(with: self.pictureLabel,
                          duration: 1.2,
                          options: [.transitionFlipFromTop, .curveEaseInOut],
                          animations: {
                          },
                          completion: nil)
        
        UIView.transition(with: self.pictureImageView,
                          duration: 1.2,
                          options: [.transitionCrossDissolve, .curveEaseInOut],
                          animations: {
                          },
                          completion: nil)
    }
}
