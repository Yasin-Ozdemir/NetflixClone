//
//  MovieApiRequestHandler.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 11.03.2024.
//

import Foundation

protocol RequestHandle{
    func handle(type : Titles ,completion : @escaping (Result<[Movie],Error>)->Void)
     var nextHandler : RequestHandle? { get set }
}

class BaseRequestHandler : RequestHandle{
    func handle(type : Titles ,completion: @escaping (Result<[Movie], Error>) -> Void) {
       
    }
   static func createChainOfResponsibility () -> BaseRequestHandler{
        let trendingMovieHandler = TrendingMovieApiHandler()
        let trendingTVHandler = TrendingTVApiHandler()
        let popularMovieHandler = PopularMovieApiHandler()
        let upcomingMovieHandler = UpcomingMovieApiHandler()
        let topRatedMovieHandler = TopRatedMovieApiHandler()
        
        trendingMovieHandler.nextHandler = trendingTVHandler
        trendingTVHandler.nextHandler = popularMovieHandler
        popularMovieHandler.nextHandler = upcomingMovieHandler
        upcomingMovieHandler.nextHandler = topRatedMovieHandler
        
       return trendingMovieHandler
    }
    var nextHandler: RequestHandle?
}

class TrendingMovieApiHandler : BaseRequestHandler{
    override func handle( type : Titles , completion: @escaping (Result<[Movie], Error> ) -> Void) {
        if type == .TrendingMovies{
            NetworkManager.manager.fetchMovies(kindUrl: Constant.trendingMovieUrl, paramUrl: nil) {result in
                switch result{
                case .success(let movies) : completion(.success(movies))
                case .failure(let error): print("trend movie alert")
                }
            }
        }else{
            nextHandler?.handle(type: type, completion: { result in
                switch result{
                case .success(let movies) : completion(.success(movies))
                case .failure(let err) : print("error")
                }
            })
        }
    }
}

class TrendingTVApiHandler : BaseRequestHandler{
    override func handle( type : Titles , completion: @escaping (Result<[Movie], Error> ) -> Void) {
        if type == .TrendingTv{
            NetworkManager.manager.fetchMovies(kindUrl: Constant.trendingTVUrl, paramUrl: nil) {result in
                switch result{
                case .success(let movies) : completion(.success(movies))
                case .failure(let error): print("trend tv alert")
                }
            }
        }else{
            nextHandler?.handle(type: type, completion: { result in
                switch result{
                case .success(let movies) : completion(.success(movies))
                case .failure(let err) : print("error")
                }
            })
        }
    }
}

class PopularMovieApiHandler : BaseRequestHandler{
    override func handle( type : Titles , completion: @escaping (Result<[Movie], Error> ) -> Void) {
        if type == .Popular{
            NetworkManager.manager.fetchMovies(kindUrl: Constant.popularMovieUrl, paramUrl: nil) {result in
                switch result{
                case .success(let movies) : completion(.success(movies))
                case .failure(let error): print("popular movie alert")
                }
            }
        }else{
            nextHandler?.handle(type: type, completion: { result in
                switch result{
                case .success(let movies) : completion(.success(movies))
                case .failure(let err) : print("error")
                }
            })
        }
    }
}


class UpcomingMovieApiHandler : BaseRequestHandler{
    override func handle( type : Titles , completion: @escaping (Result<[Movie], Error> ) -> Void) {
        if type == .Upcoming{
            NetworkManager.manager.fetchMovies(kindUrl: Constant.upComingMovieUrl, paramUrl: nil) {result in
                switch result{
                case .success(let movies) : completion(.success(movies))
                case .failure(let error): print("popular movie alert")
                }
            }
        }else{
            nextHandler?.handle(type: type, completion: { result in
                switch result{
                case .success(let movies) : completion(.success(movies))
                case .failure(let err) : print("error")
                }
            })
        }
    }
}



class TopRatedMovieApiHandler : BaseRequestHandler{
    override func handle( type : Titles , completion: @escaping (Result<[Movie], Error> ) -> Void) {
        if type == .TopRated{
            NetworkManager.manager.fetchMovies(kindUrl: Constant.topRatedUrl, paramUrl: nil) {result in
                switch result{
                case .success(let movies) : completion(.success(movies))
                case .failure(let error): print("popular movie alert")
                }
            }
        }else{
            nextHandler?.handle(type: type, completion: { result in
                switch result{
                case .success(let movies) : completion(.success(movies))
                case .failure(let err) : print("error")
                }
            })
        }
    }
}
