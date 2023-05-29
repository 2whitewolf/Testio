//
//  RealmService.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 26.05.2023.
//

import Foundation
import RealmSwift
import RxSwift

enum RealmError: Error {
    case noObjectFound
    case realmNotConfigured
}

class RealmService {
    func saveObjects(_ objects: [TestRM]) -> Completable {
        return Completable.create { completable in
            do {
                let realm = try Realm()
                try realm.write {
                    
                   realm.add(objects, update: .all)
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    func update(_ objects: TestRM) -> Single<Void> {
        return Single.deferred { 
            do {
                let realm = try Realm()
                try realm.write {
                  realm.add(objects, update: .modified)
                
                }
                return .just(())
            } catch {
                return .error(error)
            }
        }
    }
    
    func fetchTests() -> Observable<[TestRM]> {
        return Observable.create { observer in
            do {
                let realm = try Realm()
                let persons = realm.objects(TestRM.self)
                observer.onNext(Array(persons))
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
}
