//
//  HomeVC.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 20.02.2024.
//

import UIKit

enum Titles : Int{
    
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeVC: UIViewController {
    
    private let tableView : UITableView =  {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.cellID)
        return tableView
    }()
    
    private let sectionTitles = ["Trending Movies" , "Popular" , "Trending TV" , "Upcoming Movies" , "Top Rated"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        setupNavBar()
        tableView.tableHeaderView = HomeTableViewHeader(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
        view.addSubview(tableView)
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = view.bounds
    }
    
 
    
    func setupNavBar(){
        var navbarImage = UIImage(named: "netflixnavlogo")
        navbarImage = navbarImage?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        navigationController?.setupNavBar(backgroundColor: .systemBackground, textColor: .white, tintColor: .white)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: navbarImage, style: UIBarButtonItem.Style.done, target: self, action: nil)
 navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "person"), style: UIBarButtonItem.Style.done, target: self, action: nil), UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: UIBarButtonItem.Style.done, target: self, action: nil)]
    }
}





extension HomeVC : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.cellID, for: indexPath) as? HomeTableViewCell else{
            return UITableViewCell()
        }
        
        
        switch indexPath.section{
            case Titles.TrendingMovies.rawValue :
                NetworkManager.manager.fetchMovies(kindUrl: "trending/movie/day") {result in
                    switch result{
                    case .success(let movies) : cell.configureCell(movieList: movies)
                    case .failure(let error): print("trend movie alert")
                    }
                }
        case Titles.TrendingTv.rawValue :
            NetworkManager.manager.fetchMovies(kindUrl: "trending/tv/day") {result in
                switch result{
                case .success(let movies) : cell.configureCell(movieList: movies)
                case .failure(let error): print("trend movie alert")
                }
            }
            
        case Titles.Popular.rawValue :
            NetworkManager.manager.fetchMovies(kindUrl: "movie/popular") {result in
                switch result{
                case .success(let movies) : cell.configureCell(movieList: movies)
                case .failure(let error): print("trend movie alert")
                }
            }
            
        case Titles.Upcoming.rawValue :
            NetworkManager.manager.fetchMovies(kindUrl: "movie/upcoming") {result in
                switch result{
                case .success(let movies) : cell.configureCell(movieList: movies)
                case .failure(let error): print("trend movie alert")
                }
            }
            
        case Titles.TopRated.rawValue :
            NetworkManager.manager.fetchMovies(kindUrl: "movie/top_rated") {result in
                switch result{
                case .success(let movies) : cell.configureCell(movieList: movies)
                case .failure(let error): print("trend movie alert")
                }
            }
            
        default:
            print("fajofajıfajajıp")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
           guard let header = view as? UITableViewHeaderFooterView else {return}
           header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
           header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
           header.textLabel?.textColor = .white
           header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
       }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
 

}
