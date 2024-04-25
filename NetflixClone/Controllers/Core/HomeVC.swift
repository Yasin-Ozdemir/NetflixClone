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
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    private let sectionTitles = ["Trending Movies" , "Trending TV" , "Popular" , "Upcoming Movies" , "Top Rated"]
    
    private let requestHandler = BaseRequestHandler.createChainOfResponsibility()

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
         /* switch indexPath.section{
            case Titles.TrendingMovies.rawValue :
            NetworkManager.manager.fetchMovies(kindUrl: Constant.trendingMovieUrl, paramUrl: nil) {result in
                    switch result{
                    case .success(let movies) : cell.configureCell(movieList: movies)
                    case .failure(let error): print("trend movie alert")
                    }
                }
        case Titles.TrendingTv.rawValue :
            NetworkManager.manager.fetchMovies(kindUrl: Constant.trendingTVUrl , paramUrl: nil) {result in
                switch result{
                case .success(let movies) : cell.configureCell(movieList: movies)
                case .failure(let error): print("trend movie alert")
                }
            }
            
        case Titles.Popular.rawValue :
            NetworkManager.manager.fetchMovies(kindUrl: Constant.popularMovieUrl , paramUrl: nil) {result in
                switch result{
                case .success(let movies) : cell.configureCell(movieList: movies)
                case .failure(let error): print("trend movie alert")
                }
            }
            
        case Titles.Upcoming.rawValue :
            NetworkManager.manager.fetchMovies(kindUrl: Constant.upComingMovieUrl , paramUrl: nil) {result in
                switch result{
                case .success(let movies) : cell.configureCell(movieList: movies)
                case .failure(let error): print("trend movie alert")
                }
            }
            
        case Titles.TopRated.rawValue :
            NetworkManager.manager.fetchMovies(kindUrl: Constant.topRatedUrl , paramUrl: nil) {result in
                switch result{
                case .success(let movies) : cell.configureCell(movieList: movies)
                case .failure(let error): print("trend movie alert")
                }
            }
            
        default:
            break
        }*/
        var title : Titles?
        switch indexPath.section{
        case Titles.TrendingMovies.rawValue : title = .TrendingMovies
        case Titles.TrendingTv.rawValue :title = .TrendingTv
        case Titles.Popular.rawValue:title = .Popular
        case Titles.Upcoming.rawValue:title = .Upcoming
        case Titles.TopRated.rawValue:title = .TopRated
        default : break
        }
        self.requestHandler.handle(type: title ?? Titles.Popular) { result in
            switch result{
            case .success(let movies) : cell.configureCell(movieList: movies)
            case .failure(let error): print("trend movie alert")
            }
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        205
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

extension HomeVC: CollectionViewDidTapDelegate {
    func didTapCollectionViewCell(movie: Movie, videoId: String) {
       DispatchQueue.main.async {
            let moviePreviewVC = MoviePreviewVC()
            moviePreviewVC.configureView(movie: movie, videoId: videoId)
            let vc = UINavigationController(rootViewController: moviePreviewVC)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
 
           
        }
    }
    
    
}
