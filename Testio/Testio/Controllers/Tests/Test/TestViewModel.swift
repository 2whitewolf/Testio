//
//  TestViewModel.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 28.05.2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import UIKit
import AVFoundation

class TestViewModel {
    let test: TestModel
    
    
    init(test: TestModel) {
        self.test = test
    }
    struct Input {
        let viewWillAppearTrigger: Driver<Void>
        let selectedModel: Driver<TestModel>
        let failedTrigger: Driver<Void>
        let passedTrigger: Driver<Void>
    }
    struct Output {
        let close : Driver<Void>
        let action: BehaviorRelay<Bool>
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        let realmService = RealmService()
        
        let action = BehaviorRelay<Bool>(value: false)
        
        let testsFromRealm = realmService.fetchTests()
            .compactMap{ $0.map{ $0.toMain()}}
        //            .asDriver(onErrorJustReturn: [])
        
        
        
        
        Observable.combineLatest(testsFromRealm, input.selectedModel.asObservable())
            .flatMapLatest{ tests, selected -> Single<Void> in
                if tests.contains(where: { $0.id == selected.id}) {
                    return   updateTest(model: TestModel(id: selected.id, test: selected.test, opened: true, passed: selected.passed))
                }
                return .just(())
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        
        let passedTr = input.passedTrigger.withLatestFrom(input.selectedModel)
            .flatMap{ model -> Driver<Void> in
                return updateTest(model: TestModel(id: model.id, test: model.test, opened: true, passed: true)).asDriver(onErrorJustReturn: ())
            }
        
        let failed = input.failedTrigger.withLatestFrom(input.selectedModel)
            .flatMap{ model -> Driver<Void> in
                return updateTest(model: TestModel(id: model.id, test: model.test, opened: true, passed: false)).asDriver(onErrorJustReturn: ())
            }
        
        //                updateTest(model: TestModel(id: self.test.id, test: self.test.test, opened: true, passed: true))
        //            })
        //                .drive()
        //                .disposed(by: disposeBag)
        
        let close = Driver.merge(passedTr, failed)
        
        
        
        
        input.selectedModel
            .do(onNext: { test in
                switch test.test {
                    
                case .Microphone:
                    testMicrophone()
                    break
                case .Vibration:
                    testVibration()
                case .GPS:
                    testGPS()
                case .LCD:
                    break
                    //                    test
                }
            })
                .drive()
                .disposed(by: disposeBag)
                
                
                func updateTest(model: TestModel) -> Single<Void>{
                    
                    realmService.update(model.toRealm())
                    //                .subscribe()
                    //                .disposed(by: disposeBag)
                    
                }
                
                func testGPS() {
                    Connection.default.testGPS(completion: {  (result, _) in
                        updateTest(model: TestModel(id: self.test.id, test: self.test.test, opened: self.test.opened, passed: result ?? false))
                            .subscribe()
                            .disposed(by: disposeBag)
                        action.accept(true)
                        
                    })
                    
                    
                }
                
                
                func testVibration() {
                    
                    UIDevice.vibrate()
                }
                
                
                
                func testMicrophone() {
                    Sound.default.test(type: .microphone, completion: { (result, _) in
                        updateTest(model: TestModel(id: self.test.id, test: self.test.test, opened: self.test.opened, passed: result ?? false))
                            .subscribe()
                            .disposed(by: disposeBag)
                        action.accept(true)
                    })
                }
                
                return Output(close: close,action: action)
                }
    
    
    
}


extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
