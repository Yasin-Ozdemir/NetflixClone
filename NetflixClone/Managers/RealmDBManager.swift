//
//  RealmDBManager.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 6.03.2024.
//

import Foundation
import RealmSwift
enum RealmDBError : Error{
    case saveError
    case fetchError
    case deleteError
}
class RealmDBManager{
    
    private init (){
        
    }
    
    static let shared = RealmDBManager()
    
    let realm = try? Realm()
    func saveToRealDB(movie : Movie , completion : @escaping (Result<Void,Error>)-> Void){
        print(Realm.Configuration.defaultConfiguration.fileURL)
        let DBmodel = RealmDBModel()
        DBmodel.id = Int64(movie.id)
        DBmodel.name = movie.original_name ?? movie.original_title ?? ""
        DBmodel.poster_path = movie.poster_path!
        DBmodel.url = movie.overview!
        guard let realm = realm else{
            return
        }
        
        do{
            try realm.write {
                
                realm.add(DBmodel)
                print("save Success")
                completion(.success(()))
                
            }}catch{
                completion(.failure(RealmDBError.saveError))
                print("saveError")
            }
        
        
    }
    
    func deleteFromRealDB(model : RealmDBModel , completion : @escaping (Result<Void,Error>)-> Void ){
        guard let realm = realm else{
            return
            
        }
        do{
            try realm.write({
                realm.delete(model)
                completion(.success(()))
            })
        }catch{completion(.failure(RealmDBError.deleteError))}
    }
    
    func fetchFromRealDB(completion : @escaping (Result<[RealmDBModel],Error>)-> Void){
        guard let realm = realm else{
            completion(.failure(RealmDBError.fetchError))
            return
        }
        var resultArray : [RealmDBModel] = []
        let results = realm.objects(RealmDBModel.self)
        
        for result in results{
            resultArray.append(result)
        }
        
        completion(.success(resultArray))
        
    }
}
