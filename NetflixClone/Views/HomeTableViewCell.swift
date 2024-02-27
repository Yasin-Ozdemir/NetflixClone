//
//  HomeTableViewCell.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 20.02.2024.
//

import UIKit

protocol CollectionViewDidTapDelegate : AnyObject{
    func didTapCollectionViewCell(movie : Movie , videoId : String) -> Void
}

class HomeTableViewCell: UITableViewCell{
 static let cellID = "HomeTableViewCell"
    private var movieList : [Movie] = []
  private let collectionView : UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.register(TableCollectionViewCell.self, forCellWithReuseIdentifier: TableCollectionViewCell.cellID)
        return collectionView
    }()
    
    weak var delegate : CollectionViewDidTapDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(movieList : [Movie]){
        DispatchQueue.main.async {
            self.movieList = movieList

            self.collectionView.reloadData()
        }
    }
    
    func downloadMovie(movie : Movie){
        CoreDataManager.manager.downloadMovie(movie: movie) { [weak self]result in
            guard let self = self else{
                return
            }
            
            switch result {
            case .success(_) : NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let err) : print(err)
            }
        }
    }
    
}

extension HomeTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableCollectionViewCell.cellID, for: indexPath) as? TableCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(with: self.movieList[indexPath.row].poster_path ?? "")
        return cell
    }
    
    func  collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let query = self.movieList[indexPath.row].original_title ?? self.movieList[indexPath.row].original_name else{
            return
        }
        
        NetworkManager.manager.fetchMovieOnYoutube(with: query) { [weak self] result in
            guard let self = self else{return}
            switch result{
            case.success(let video) : 
                guard let delegate = self.delegate else {return}
                delegate.didTapCollectionViewCell(movie: self.movieList[indexPath.row], videoId: video.videoId)
            
            case.failure(let err) : print(err)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                print("downloaded")
                self.downloadMovie(movie: self.movieList[indexPaths[0].row])
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
    
 
    
    
}
