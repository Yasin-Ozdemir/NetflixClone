//
//  HomeTableViewHeader.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 21.02.2024.
//

import UIKit

class HomeTableViewHeader: UIView {
    
    private let playButton : UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: UIControl.State.normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButton : UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: UIControl.State.normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imageView : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "lordoftherings")
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        presentViews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    private func addGradient(){
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
    private func presentViews(){
        addSubview(imageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
        
    }
    
    private func applyConstraints(){
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 100),
            
            downloadButton.widthAnchor.constraint(equalToConstant: 100),
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
            
        
        ])
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
