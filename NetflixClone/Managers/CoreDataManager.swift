//
//  CoreDataManager.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 27.02.2024.
//

import UIKit
import Foundation
import CoreData

enum CoreDataError : Error{
    case saveError
    case fetchError
    case deleteError
}
class CoreDataManager{
    
    private init(){
        
    }
    
    static let manager = CoreDataManager()
    
    func downloadMovie(movie : Movie , completion : @escaping (Result<Void , Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let movieItem = MovieItem(context: context)
        
        movieItem.name = movie.original_name ?? movie.original_title
        movieItem.id = Int64(movie.id)
        movieItem.poster_path = movie.poster_path
        movieItem.overview = movie.overview
        do{
            try context.save()
            completion(.success(()))
        }catch{
            print(CoreDataError.saveError)
            completion(.failure(CoreDataError.saveError))
        }
        
    }
    
    func fetchMovieFromDataBase(completion : @escaping (Result<[MovieItem] , Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<MovieItem> = MovieItem.fetchRequest()
        
        do{
            let movies = try context.fetch(fetchRequest)
            completion(.success(movies))
        }catch{print(CoreDataError.fetchError)
            completion(.failure(CoreDataError.fetchError))
            
        }
    }
    
    func deleteMovieFromDataBase(movieItem : MovieItem , completion : @escaping (Result<Void,Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(movieItem)
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(CoreDataError.deleteError))
        }
    }
}
