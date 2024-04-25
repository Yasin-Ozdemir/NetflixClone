//
//  DownloadsVC.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 20.02.2024.
//

import UIKit

class DownloadsVC: UIViewController {

    private let downloadTable :UITableView = {
        let table = UITableView()
        table.register(Upcoming_Search_Downloads_TableViewCell.self, forCellReuseIdentifier: Upcoming_Search_Downloads_TableViewCell.id)
        return table
    }()
    
    private var movieList : [RealmDBModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        setupNavBar()
        setupTableView()
        view.addSubview(downloadTable)
        fetchMovieFromDataBase()
        updateTableView()
        
  
    }
    
    override func viewDidLayoutSubviews() {
        self.downloadTable.frame = view.bounds
    }
    
 
    func setupNavBar(){
        self.navigationController?.setupNavBar(backgroundColor: .systemBackground, textColor: .white, tintColor: .white)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = "Downloads"
    }
    
    func fetchMovieFromDataBase(){
       RealmDBManager.shared.fetchFromRealDB { [weak self] result in
            guard let self = self else{
                return
            }
            switch result{
            case .success(let movies) :
                self.movieList = movies
                DispatchQueue.main.async {
                    self.downloadTable.reloadData()
                }
            case .failure(let err) : print(err)
            }
            
        }
    }
    func updateTableView(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { [weak self] _ in
            guard let self = self else{
                return
            }
            self.fetchMovieFromDataBase()
        }
    }
    

}

extension DownloadsVC : UITableViewDelegate , UITableViewDataSource{
    
    
    func setupTableView(){
        self.downloadTable.delegate = self
        self.downloadTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Upcoming_Search_Downloads_TableViewCell.id, for: indexPath) as? Upcoming_Search_Downloads_TableViewCell else{
            return UITableViewCell()
        }
        
        cell.configureCell(with: self.movieList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete :
            
            RealmDBManager.shared.deleteFromRealDB(model: self.movieList[indexPath.row]) { [weak self]result in
                guard let self = self else{
                    return
                }
                
                switch result{
                case .success(_) :
                    self.movieList.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        self.downloadTable.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                    }
                case .failure(let err) : print(err)
                }
            }
           
        default : break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.movieList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        125
    }
}


