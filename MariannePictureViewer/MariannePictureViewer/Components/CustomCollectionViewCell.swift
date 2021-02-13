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
    
    func configureCell() {
        self.backgroundColor = .green;
        
        let pictureLabelFrame = CGRect(x: 0.0, y: 0.0, width: self.bounds.size.width, height: 18)
        self.pictureLabel = UILabel(frame: pictureLabelFrame)
        self.pictureLabel.font = .systemFont(ofSize: 12)
        self.pictureLabel.textColor = .blue
        self.pictureLabel.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(self.pictureLabel)
        
        let pictureImageViewFrame = CGRect(x: 0.0, y: 20.0, width: self.bounds.size.width, height: 80)
        self.pictureImageView = UIImageView(frame: pictureImageViewFrame)
        self.pictureImageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(pictureImageView)
    }
}
