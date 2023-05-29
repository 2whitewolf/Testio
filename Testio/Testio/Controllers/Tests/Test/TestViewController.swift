//
//  ViewController.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 28.05.2023.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import Then
import SnapKit

class TestViewController: UIViewController {
    
    private let viewModel: TestViewModel
    private let disposeBag: DisposeBag
    
    
    private lazy  var titleLabel = UILabel().then { label in
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private lazy var closeButton = UIButton().then{ button in
        button.setImage(UIImage(named: "failed"), for: .normal)
    }
    
    private lazy var passedButton = UIButton().then{ button in
        button.setImage(UIImage(named: "passed"), for: .normal)
        
//        button.rx.tap.bind(onNext: {_ in
//            self.close()
//        })
//        .disposed(by: disposeBag)
    }
    
    
    private lazy var testImage = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFit
    }
    
    private let test: TestModel
    
    init(test: TestModel) {
        viewModel = TestViewModel(test: test)
        disposeBag = DisposeBag()
        self.test = test
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
//        viewModel.testVibration(disposeBag: disposeBag)
        bindingSetup()
        switch test.test {
        case .GPS :
            break
            
        case .Microphone:
            addButtons()
        case .Vibration:
            addButtons()
        case .LCD:
            addButtons()
        }
        
        
    }
    
    
    private func viewSetup() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(testImage)
       
        titleLabel.text = test.test.descritpion
        testImage.image = test.test.image
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(UIScreen.screenHeight * 0.23)
        }
        
        testImage.snp.makeConstraints{ make in
            make.center.equalToSuperview()
        }
        
       
    }
    
    
    private func addButtons() {
        view.addSubview(closeButton)
        view.addSubview(passedButton)
        closeButton.snp.makeConstraints{ make in
            make.bottom.equalToSuperview().inset(70)
            make.leading.equalToSuperview().inset(UIScreen.screenWidth * 0.23)
        }
        passedButton.snp.makeConstraints{ make in
            make.top.equalTo(closeButton)
            make.trailing.equalToSuperview().inset(UIScreen.screenWidth * 0.23)
        }
    }
    
    
    private func bindingSetup(){
        let viewWillAppearTrigger = rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let selectedModel = Driver<TestModel>.just(test)
        
        
       let failedTrigger = closeButton.rx.tap.asDriver()
        let passedTrigger = passedButton.rx.tap.asDriver()
        
        
        
        
        let input = TestViewModel.Input(
            viewWillAppearTrigger: viewWillAppearTrigger,
            selectedModel: selectedModel,
            failedTrigger: failedTrigger,
            passedTrigger: passedTrigger
        )
        
        let output = viewModel.transform(input: input, disposeBag: self.disposeBag)
        
        output.close.do(onNext: {
            self.close()
        })
            .drive()
            .disposed(by: disposeBag)
            
            output.action
            .filter{ $0 }
            .subscribe(onNext: { _ in
                self.close()
            })
            .disposed(by: disposeBag)
    }
    
    
    private func close() {
        dismiss(animated: true)
    }
    
}
