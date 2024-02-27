//
//  SearchResultVC.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 24.02.2024.
//

import UIKit

class SearchResultVC: UIViewController {
    public var movies : [Movie] = []
    public let collectionView : UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10 , height: UIScreen.main.bounds.height / 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TableCollectionViewCell.self, forCellWithReuseIdentifier: TableCollectionViewCell.cellID)
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.addSubview(collectionView)
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        self.collectionView.frame = view.bounds
    }

}

extension SearchResultVC : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableCollectionViewCell.cellID, for: indexPath) as? TableCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.configureCell(with: movies[indexPath.row].poster_path ?? "")
        return cell
    }
    func  collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let query = self.movies[indexPath.row].original_title ?? self.movies[indexPath.row].original_name else{
            return
        }
        
        NetworkManager.manager.fetchMovieOnYoutube(with: query) { [weak self] result in
            guard let self = self else{return}
            switch result{
            case.success(let video) :
                DispatchQueue.main.async {
                    let moviePreviewVC = MoviePreviewVC()
                    moviePreviewVC.configureView(movie: self.movies[indexPath.row], videoId: video.videoId)
                    
                   let vc = UINavigationController(rootViewController: moviePreviewVC)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            
            case.failure(let err) : print(err)
            }
        }
        
    }
    
    
    func setupCollectionView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}
