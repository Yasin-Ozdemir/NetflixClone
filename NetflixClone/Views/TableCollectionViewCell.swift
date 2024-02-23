//
//  TableCollectionViewCell.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 20.02.2024.
//

import UIKit
import SDWebImage
class TableCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "CollectionViewCell"
    
    
    private let imageView : UIImageView = {
       let imageview = UIImageView()
        imageview.clipsToBounds = false
        return imageview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.imageView.frame = contentView.bounds
    }
    
    func configureCell(with poster_path : String){
        self.imageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/\(poster_path)"))
    }
    
}
