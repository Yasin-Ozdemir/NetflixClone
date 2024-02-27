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
    static let trendingMovieUrl = "trending/movie/day"
    static let upComingMovieUrl = "movie/upcoming"
    static let trendingTVUrl = "trending/tv/day"
    static let popularMovieUrl = "movie/popular"
    static let topRatedUrl = "movie/top_rated"
    static let discoverMoviesUrl = "discover/movie"
    static let discoverMoviesParam = "&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
    static let searchMovieUrl = "search/movie"
    static let youtubeApiKEY = "AIzaSyDQigW7cBGeiCFy73UU0OunrMH-w6xPk_Y"
    static let youtubeBaseUrl = "https://youtube.googleapis.com/youtube/v3/search?"
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
    
    func fetchMovies(kindUrl : String , paramUrl : String? , completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constant.baseUrl)\(kindUrl)?api_key=\(Constant.ApiKEY)\(paramUrl ?? "")") else{
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
    
    func fetchMovieOnYoutube(with query : String , completion : @escaping (Result<Video,Error>)-> Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) else{
            return
        }
        guard let url = URL(string: "\(Constant.youtubeBaseUrl)q=\(query)+Trailer&key=\(Constant.youtubeApiKEY)") else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: { data, response, err in
            guard let data = data , let response = response as? HTTPURLResponse ,err == nil else{
                completion(.failure(NetworkError.ServerError))
                return
            }
            
            if response.statusCode == 200 {
                do{
                   let result =  try JSONDecoder().decode(YoutubeApiModel.self, from: data)
                    
                    
                    completion(.success(result.items[0].id))
                    
                    
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
