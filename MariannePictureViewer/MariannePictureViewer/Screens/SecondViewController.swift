//
//  SecondViewController.swift
//  MariannePictureViewer
//
//  Created by Roman Kolosov on 13.02.2021.
//

import UIKit
import SDWebImage

class SecondViewController: UIViewController {
    
    // Some properties
    var pictureLabel: UILabel = UILabel()
    var pictureImageView: UIImageView = UIImageView()
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configureSecondVC()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.animateSubviews()
    }
    
    // MARK: - Configure
    
    private func configureSecondVC() {
        self.view.backgroundColor = .yellow
        
        let pictureLabelFrame = CGRect(x: 21.0, y: 111.0, width: self.view.bounds.size.width - 42.0, height: 21)
        self.pictureLabel = UILabel(frame: pictureLabelFrame)
        self.pictureLabel.font = .systemFont(ofSize: 21)
        self.pictureLabel.textColor = .blue
        self.pictureLabel.textAlignment = NSTextAlignment.center
        self.pictureLabel.alpha = 0
        
        self.view.addSubview(self.pictureLabel)
        
        let pictureImageViewFrame = CGRect(x: 21.0, y: 111.0 + pictureLabel.frame.height + 80.0, width: self.view.bounds.size.width - 42.0, height: 180.0)
        self.pictureImageView = UIImageView(frame: pictureImageViewFrame)
        self.pictureImageView.contentMode = .scaleAspectFill
        
        self.view.addSubview(pictureImageView)
    }
    
    func lookConfigure(with photo: PhotoElementData, photoService: CollectionViewPhotoService?, indexPath: IndexPath) {
        
        guard let photoStringURL = photo.downloadURL else {
            fatalError()
        }
        self.pictureLabel.text = "by \(photo.author ?? "")"
        
        // SDWebImage used since it is the most easy way to download images avoiding its mismatch in cells
        self.pictureImageView.sd_setImage(with: URL(string: photoStringURL)) { [self] (image, error, SDImageCacheType, url) in
            
            self.animateSubviews()
        }
        
        // Way of use image caches
        //self.pictureImageView.image = photoService?.getPhoto(atIndexPath: indexPath, byUrl: photoStringURL)
    }
    
    // MARK: - Animations
    
    private func animateSubviews() {
        UIView.transition(with: self.pictureLabel,
                          duration: 2.1,
                          options: [.transitionCrossDissolve, .curveEaseInOut],
                          animations: {
                            self.pictureLabel.alpha = 1
                          },
                          completion: nil)
    }
}
