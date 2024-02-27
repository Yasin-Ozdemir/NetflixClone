//
//  MoviePreviewVC.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 26.02.2024.
//

import UIKit
import WebKit
class MoviePreviewVC: UIViewController {
    
    private let overviewLabel : UILabel = {
      let label = UILabel()
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = 10
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
          label.textAlignment = .left
          label.textColor = .label
          label.font = .systemFont(ofSize: 22)
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
    }()
    
    private let webKit : WKWebView = {
       let webKit = WKWebView()
        webKit.translatesAutoresizingMaskIntoConstraints = false
        return webKit
    }()
    
    private let downloadButton : UIButton = {
       let button = UIButton()
        button.setTitle("Download", for: UIControl.State.normal)
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        setupNavBar()
        presentViews()
        setupConstarints()
       
       
    }
    
    @objc func goBack(){
        self.dismiss(animated: true)
    }
    func setupNavBar(){
        self.navigationController?.setupNavBar(backgroundColor: .systemBackground, textColor: .white, tintColor: .white)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItem.Style.done, target: self, action: #selector(goBack))
    }
    func presentViews(){
        self.view.addSubview(webKit)
        self.view.addSubview(titleLabel)
        self.view.addSubview(overviewLabel)
        self.view.addSubview(downloadButton)
    }
    func setupConstarints(){
        NSLayoutConstraint.activate([
            self.webKit.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.webKit.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            self.webKit.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            self.webKit.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.40),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.webKit.bottomAnchor, constant: 20),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            
            self.overviewLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.overviewLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            self.overviewLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            
            self.downloadButton.topAnchor.constraint(equalTo: self.overviewLabel.bottomAnchor, constant: 10),
            self.downloadButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.downloadButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.33),
            self.downloadButton.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.09)
            
        
        ])
    }
    
    func configureView(movie : Movie , videoId : String){
        self.overviewLabel.text = movie.overview ?? "Unkown"
        self.titleLabel.text = movie.original_name ?? movie.original_title ?? "unkown"
        guard let url = URL(string: "https://www.youtube.com/embed/\(videoId)") else {
            return
        }
        self.webKit.load(URLRequest(url: url))
    }

}
