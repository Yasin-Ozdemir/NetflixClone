//
//  Upcoming_Search_Downloads_TableViewCell.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 23.02.2024.
//

import UIKit
import SDWebImage

class Upcoming_Search_Downloads_TableViewCell: UITableViewCell {

    static let id = "Upcoming_Search_Downloads_TableViewCell"
    var movie : Movie?
    weak var delegate : CollectionViewDidTapDelegate?
    private let posterImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let playButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(Any?.self, action: #selector(fetchMovieOnYoutube), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        contentView.addSubview(playButton)
        contentView.addSubview(titleLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            posterImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
   
            
        ])
    }
    
    public func configureCell(with model : Movie) {
        self.movie = model
        self.posterImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/\(model.poster_path ?? "")"))
        self.titleLabel.text = model.original_name ?? model.original_title ?? "unkown"
    }
    
    public func configureCell(with modelItem : MovieItem){
        self.posterImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/\(modelItem.poster_path ?? "")"))
        self.titleLabel.text = modelItem.name ?? "unkown"
    }
    
   @objc func fetchMovieOnYoutube(){
       NetworkManager.manager.fetchMovieOnYoutube(with: titleLabel.text ?? "unkown") { [weak self] result in
           guard let self = self , let delegate = self.delegate , let movie = movie else{
               return
           }
           switch result{
           case.success(let video) : delegate.didTapCollectionViewCell(movie: movie, videoId: video.videoId)
           case .failure(let err) : print(err)
           }
       }
    }
    
}
