//
//  NetworkManager.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 22.02.2024.
//

import Foundation

struct Constant{
    static let ApiKEY = "697d439ac993538da4e3e60b54e762cd"
    static let baseUrl = "https://api.themoviedb.org/3/"
}

enum NetworkError : Error{
    case ParseError
    case ConnectionError
    case ServerError
}

class NetworkManager{
    private init(){
        
    }
    
    static let manager = NetworkManager()
    
    func fetchMovies(kindUrl : String , completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constant.baseUrl)\(kindUrl)?api_key=\(Constant.ApiKEY)") else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: { data, response, err in
            guard let data = data , let response = response as? HTTPURLResponse ,err == nil else{
                completion(.failure(NetworkError.ServerError))
                return
            }
            
            if response.statusCode == 200 {
                do{
                   let result =  try JSONDecoder().decode(MovieResult.self, from: data)
                   
                        completion(.success(result.results))
                    
                    
                }catch{
                    completion(.failure(NetworkError.ParseError))
                }
            }else{
                completion(.failure(NetworkError.ConnectionError))
            }
        })
        
        task.resume()
    }
    
    
}
