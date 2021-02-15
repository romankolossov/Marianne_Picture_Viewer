//
//  SecondViewController.swift
//  MariannePictureViewer
//
//  Created by Roman Kolosov on 13.02.2021.
//

import UIKit

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
        self.pictureLabel.isHidden = true
        
        self.view.addSubview(self.pictureLabel)
        
        let pictureImageViewFrame = CGRect(x: 21.0, y: 111.0 + pictureLabel.frame.height + 80.0, width: self.view.bounds.size.width - 42.0, height: 180.0)
        self.pictureImageView = UIImageView(frame: pictureImageViewFrame)
        self.pictureImageView.contentMode = .scaleAspectFill
        
        self.view.addSubview(pictureImageView)
    }
    
    // MARK: - Animations
    
    private func animateSubviews() {
        UIView.transition(with: self.pictureLabel,
                          duration: 1.0,
                          options: [.transitionCrossDissolve, .curveEaseInOut],
                          animations: {
                            self.pictureLabel.isHidden = false
                          },
                          completion: nil)
    }
}
