//
//  CustomCollectionViewCell.swift
//  MariannePictureViewer
//
//  Created by Roman Kolosov on 13.02.2021.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    // Some properties
    var pictureLabel : UILabel = UILabel()
    var pictureImageView : UIImageView = UIImageView()
    
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
        self.backgroundColor = .brown
        
        let pictureLabelFrame = CGRect(x: 2.0, y: 2.0, width: self.bounds.size.width - 4, height: 12.0)
        self.pictureLabel = UILabel(frame: pictureLabelFrame)
        self.pictureLabel.font = .systemFont(ofSize: 12)
        self.pictureLabel.textColor = .purple
        self.pictureLabel.textAlignment = NSTextAlignment.center
        
        self.contentView.addSubview(self.pictureLabel)
        
        let pictureImageViewFrame = CGRect(x: 0.0, y: 2.0 + pictureLabel.frame.height + 2.0 , width: self.bounds.size.width, height: 82.0)
        self.pictureImageView = UIImageView(frame: pictureImageViewFrame)
        self.pictureImageView.contentMode = .scaleAspectFit
        
        self.contentView.addSubview(pictureImageView)
    }
}
