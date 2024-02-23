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
        table.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.id)
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
        NetworkManager.manager.fetchMovies(kindUrl: "movie/upcoming") { [weak self] result in
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

extension UpcomingVC : UITableViewDelegate , UITableViewDataSource{
    
    
    func setupTableView(){
        self.upcomingTable.delegate = self
        self.upcomingTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.id, for: indexPath) as? UpcomingTableViewCell else{
            return UITableViewCell()
        }
        
        cell.configureCell(title: self.movieList[indexPath.row].original_title ?? self.movieList[indexPath.row].original_name ?? "", posterPath: self.movieList[indexPath.row].poster_path ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.movieList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        125
    }
}
