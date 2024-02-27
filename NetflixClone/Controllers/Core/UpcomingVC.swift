//
//  UpcomingVC.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 20.02.2024.
//

import UIKit

class UpcomingVC: UIViewController {
    
    private let upcomingTable :UITableView = {
        let table = UITableView()
        table.register(Upcoming_Search_Downloads_TableViewCell.self, forCellReuseIdentifier: Upcoming_Search_Downloads_TableViewCell.id)
        return table
    }()
    
    private var movieList : [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        setupNavBar()
        setupTableView()
        view.addSubview(upcomingTable)
        
        fetchUpcomings()
    }
    
    override func viewDidLayoutSubviews() {
        self.upcomingTable.frame = view.bounds
    }
    
    func fetchUpcomings(){
        NetworkManager.manager.fetchMovies(kindUrl: "movie/upcoming", paramUrl: nil) { [weak self] result in
            guard let self = self else{
                return
            }
            switch result {
            case .success(let movies) : 
                self.movieList = movies
                DispatchQueue.main.async {
                    self.upcomingTable.reloadData()
                }
            case . failure(let error) : print("this is upcoming vc error")
            }
        }
    }

    func setupNavBar(){
        self.navigationController?.setupNavBar(backgroundColor: .systemBackground, textColor: .white, tintColor: .white)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = "Upcoming"
    }
    
    

}

extension UpcomingVC : UITableViewDelegate , UITableViewDataSource , CollectionViewDidTapDelegate{
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
        self.upcomingTable.delegate = self
        self.upcomingTable.dataSource = self
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
