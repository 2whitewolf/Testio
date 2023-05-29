//
//  TestViewModel.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 26.05.2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import UIKit

class TestsViewModel {
    struct Input {
        let viewWillAppearTrigger: Driver<Void>
        let selectedModel: Driver<RegularSectionItem>
    }
    struct Output {
        let sections: Driver<[RegularSectionModel]>
        let nextPage: Driver<TestVM?>
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        
        
        
        
        let realmService = RealmService()
        let testsFromRealm = BehaviorRelay<[TestModel]>(value: [])
        //        let testsFromRealm = realmService.fetchTests()
        //            .compactMap{ $0.map{ $0.toMain()}}
        //            .asDriver(onErrorJustReturn: [])
        
        input.viewWillAppearTrigger
            .do(onNext: { _ in
                fetch()
            })
            .drive()
                .disposed(by: disposeBag)
                
                
                func saveTests(models: [TestModel]) -> Completable {
                    return  realmService.saveObjects(models.map{ $0.toRealm() })
                }
                func fetch(){
                    realmService.fetchTests()
                        .compactMap{ $0.map{ $0.toMain()}}
                    
                        .do(onNext: {
                            testsFromRealm.accept($0)
                        })
                            .subscribe()
                            .disposed(by: disposeBag)
                            }
                
                
                
                
                
                
                
                let tests = Observable.combineLatest(testsFromRealm.asObservable().distinctUntilChanged(), input.viewWillAppearTrigger.asObservable()){ tests, _ -> [TestVM] in
                    if tests.isEmpty {
                        
                        return defaultTests
                            .map{
                                TestVM(model: $0, selected: BehaviorRelay<Bool>(value: false))
                            }
                    }
                    return tests
                        .map{
                            TestVM(model: $0, selected: BehaviorRelay<Bool>(value: false))
                        }
                }
                
                
                
                tests.flatMapLatest{ models in
                    saveTests(models: models.map{ $0.model})
                }
                .subscribe()
                .disposed(by: disposeBag)
        
        //        let tests = testsList{ $0.map{TestVM(model: $0, selected: BehaviorRelay<Bool>(value: false))}}
        let sections = tests
            .flatMap{ self.makeSections(from: $0)}
        
        
        //        let selectedId = input.viewWillAppearTrigger.withLatestFrom(input.selectedModel)
        //            .flatMapLatest{ model -> UUID in
        //
        //            }
        //            .flatMap{ model in
        //                switch model {
        //                case .SelectionItemWithId(icon: _, title: _, selected: _, passed: _, id: let id):
        //                    return id
        //                }
        //            }
        //            .map{ $0!}
        
        
        
        let selectedId = input.selectedModel
            .map{ model in
                switch model {
                case .SelectionItemWithId(icon: _, title: _, selected: _, passed: _, id: let id):
                    return id
                }
            }
            .map{ $0!}
        
        
        
//        tests.asDriver(onErrorJustReturn: []).withLatestFrom(selectedId)
//            .flatMap{ id -> TestVM? in
//                
//            }
        let model = Driver.combineLatest(tests.asDriver(onErrorJustReturn: []), selectedId) { models, selectedId -> TestVM? in
            
            let model = models.first(where: { $0.model.id == selectedId })
            guard let model = model else {
                return nil
            }
            return model
        }
        
        return  Output(sections: sections.asDriver(onErrorJustReturn: []), nextPage: model)
        
        
    }
}

extension TestsViewModel {
    private func makeSections(from models: [TestVM]) -> Driver<[RegularSectionModel]> {
        guard !models.isEmpty else { return Driver.just([]) }
        let items = models.enumerated().map { index, model -> RegularSectionItem in
            let image = UIImage(named: model.model.opened ? model.model.test.imageOn : model.model.test.imageOff)!
            return RegularSectionItem.SelectionItemWithId(icon: image, title: model.model.test.name, selected: model.selected.asDriver(), passed: Driver<Bool>.just(model.model.passed), id: model.model.id)
        }
        
        let sections = [
            RegularSectionModel(header: nil, footer: nil, items: items),
        ]
        return Driver.just(sections)
    }
    
    
    
}

fileprivate var defaultTests:[TestModel] = [
    TestModel(id: UUID(), test: .LCD, opened: false, passed: false),
    TestModel(id: UUID(), test: .GPS, opened: false, passed: false),
    TestModel(id: UUID(), test: .Microphone, opened: false, passed: false),
    TestModel(id: UUID(), test: .Vibration, opened: false, passed: false)
    
]


struct TestVM{
    var model: TestModel
    let selected: BehaviorRelay<Bool>
}
