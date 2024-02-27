//
//  SearchVC.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 20.02.2024.
//

import UIKit

class SearchVC: UIViewController {

    private let searchVCTable :UITableView = {
        let table = UITableView()
        table.register(Upcoming_Search_Downloads_TableViewCell.self, forCellReuseIdentifier: Upcoming_Search_Downloads_TableViewCell.id)
        return table
    }()
    
    private let searchController : UISearchController = {
       let searchController = UISearchController(searchResultsController: SearchResultVC())
        searchController.searchBar.placeholder = "Search for a Movie or a Tv show"
        return searchController
    }()
    
    private var movieList : [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        setupNavBar()
        setupTableView()
        view.addSubview(searchVCTable)
        
        fetchDiscoverMovies()
        setupSearchController()
    }
    
    override func viewDidLayoutSubviews() {
        self.searchVCTable.frame = view.bounds
    }
    
    func fetchDiscoverMovies(){
        NetworkManager.manager.fetchMovies(kindUrl: Constant.discoverMoviesUrl, paramUrl: Constant.discoverMoviesParam) { [weak self] result in
            guard let self = self else{
                return
            }
            switch result{
            case .success(let movies) :
                self.movieList = movies
                DispatchQueue.main.async {
                    self.searchVCTable.reloadData()
                }
            case .failure(let err) : print("searchVC error alert")
            }
        }
    }

    func setupNavBar(){
        self.navigationController?.setupNavBar(backgroundColor: .systemBackground, textColor: .white, tintColor: .white)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = "Search"
        self.navigationItem.searchController = self.searchController
    }
    
    

}

extension SearchVC : UITableViewDelegate , UITableViewDataSource , CollectionViewDidTapDelegate{
    func didTapCollectionViewCell(movie: Movie, videoId: String) {
        DispatchQueue.main.async {
            let moviePreviewVC = MoviePreviewVC()
            moviePreviewVC.configureView(movie: movie, videoId: videoId)
            
           let vc = UINavigationController(rootViewController: moviePreviewVC)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }

    }
    
    func setupTableView(){
        self.searchVCTable.delegate = self
        self.searchVCTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Upcoming_Search_Downloads_TableViewCell.id, for: indexPath) as? Upcoming_Search_Downloads_TableViewCell else{
            return UITableViewCell()
        }
        
        cell.configureCell(with: movieList[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.movieList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        125
    }
}

extension SearchVC : UISearchResultsUpdating{
    func setupSearchController(){
        self.searchController.searchResultsUpdater = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard var query = searchController.searchBar.text , query.trimmingCharacters(in: .whitespaces).isEmpty == false , query.trimmingCharacters(in: .whitespaces).count > 2 ,
              let resultController = searchController.searchResultsController as? SearchResultVC else{
            return
        }
        if let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed){
            
            NetworkManager.manager.fetchMovies(kindUrl: Constant.searchMovieUrl, paramUrl: "&query=\(query)") {  result in
                
              
                switch result{
                case.success(let movies) :
                    resultController.movies = movies
                    DispatchQueue.main.async {
                        resultController.collectionView.reloadData()
                    }
                case.failure(let err) : print(err.localizedDescription)
                }
            }
            
        }
            
        }
    }
    
    

    


