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
    private var cachedImages: Dictionary = [String : UIImage]()
    
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
        self.backgroundColor = .tertiarySystemFill
        
        let pictureLabelFrame = CGRect(x: indent, y: indent,
                                       width: self.bounds.size.width - indent * 2,
                                       height: 26.0)
        
        self.pictureLabel = UILabel(frame: pictureLabelFrame)
        self.pictureLabel.font = .systemFont(ofSize: 15)
        self.pictureLabel.textColor = .purple
        self.pictureLabel.textAlignment = NSTextAlignment.center
        
        self.contentView.addSubview(self.pictureLabel)
        
        let picX = (self.bounds.size.width / 2 - (self.bounds.size.height - pictureLabel.frame.height) * 16 / 9 / 2) >= 0 ?
            (self.bounds.size.width / 2 - (self.bounds.size.height - pictureLabel.frame.height) * 16 / 9 / 2) : 0
        let picWidth = (self.bounds.size.height - pictureLabel.frame.height) * 16 / 9 <= self.bounds.size.width ?
            (self.bounds.size.height - pictureLabel.frame.height) * 16 / 9 :
            self.bounds.size.width
        
        let pictureImageViewFrame = CGRect(x: picX, y: indent + pictureLabel.frame.height,
                                           width: picWidth,
                                           height: self.bounds.size.height - pictureLabel.frame.height)
        
        self.pictureImageView = UIImageView(frame: pictureImageViewFrame)
        self.pictureImageView.contentMode = .scaleAspectFit
        
        self.contentView.addSubview(pictureImageView)
    }
    
    func lookConfigure(with photo: PhotoElementData, photoService: CollectionViewPhotoService?, indexPath: IndexPath) {
        
        guard let photoStringURL = photo.downloadURL else {
            fatalError()
        }
        
        /* SDWebImage use
         SDWebImage used since it is the most easy way to download images
         avoiding its mismatch in cells. Also it shows the download activity */
        self.pictureImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        // RAM cache use
        if let image = cachedImages[photoStringURL] {
            #if DEBUG
            print("\(photoStringURL) : Cached image with SDWebImage")
            #endif
            self.pictureImageView.image = image
            self.pictureLabel.text = photo.author
        } else {
            self.pictureImageView.sd_setImage(with: URL(string: photoStringURL)) { [weak self] (image, error, SDImageCacheType, url) in
                #if DEBUG
                print("\(photoStringURL) : Network image with SDWebImage")
                #endif
                self?.pictureLabel.text = photo.author
                self?.animateSubviews()
                
                guard let image = image else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.cachedImages[photoStringURL] = image
                }
            }
        }
        /* SDWebImage use end */
 
        /* Way of use RAM, file image caches and network download with CollectionViewPhotoService.
         It is slower than the use SDWebImage for network.
         Also it causes mismatch images when cache fomm file used.
         Stack - CollectionViewPhotoService.
         In order to use CollectionViewPhotoService, plese
         1. comment the code between "SDWebImage use - SDWebImage use end";
         2. comment line "private var cachedImages: Dictionary = [String : UIImage]()"
         3. remove comments from the use of photoService and "self.pictureLabel.tex=" in the lines bellow;
         4. perform actions following instructions in SecondViewController.swift file.
         */
        //self.pictureImageView.image = photoService?.getPhoto(atIndexPath: indexPath, byUrl: photoStringURL)
        //self.pictureLabel.text = photo.author
        
        animate()
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
                          options: [.transitionFlipFromRight, .curveEaseInOut],
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
