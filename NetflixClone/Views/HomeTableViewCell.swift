//
//  HomeTableViewCell.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 20.02.2024.
//

import UIKit

class HomeTableViewCell: UITableViewCell{
 static let cellID = "HomeTableViewCell"
    private var movieList : [Movie] = []
    private let collectionView : UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TableCollectionViewCell.self, forCellWithReuseIdentifier: TableCollectionViewCell.cellID)
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .blue
        addSubview(collectionView)
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
        self.movieList = movieList
        DispatchQueue.main.async {
            self.collectionView.reloadData()
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
    
    
}
