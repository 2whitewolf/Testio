//
//  BatteryViewController.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 29.05.2023.
//

import UIKit
import SnapKit
import DeviceKit
import RxSwift
import RxCocoa
import Then
final class BatteryViewController: UIViewController {
    
    
    private let batteryCharge = BatteryInfoView()
   
    private let batterylevel = BatteryInfoView()
    private let voltage = BatteryInfoView()
    
    private let viewModel: BatteryViewModel
    private var disposeBag: DisposeBag
    
    init() {
        viewModel = BatteryViewModel()
        disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("app")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        viewSetup()
        bindingSetup()
        navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    func viewSetup(){
        view.addSubviews(batterylevel, batteryCharge, voltage)
        
        batterylevel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(UIScreen.screenHeight * 0.2)
            make.height.equalTo(90)
            make.width.equalTo(130)
        }
        batteryCharge.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(batterylevel.snp.bottom).offset(20)
            make.height.equalTo(90)
            make.width.equalTo(130)
        }
        voltage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(batteryCharge.snp.bottom).offset(20)
            make.height.equalTo(90)
            make.width.equalTo(130)
        }

    }
    
    func bindingSetup() {
        let viewWillAppearTrigger = rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
       
        
        
        let input = BatteryViewModel.Input(
            viewWillAppearTrigger: viewWillAppearTrigger
        )
        
        let output = viewModel.transform(input: input, disposeBag: self.disposeBag)
        
        output.batteryStatus
            .do(onNext: {
                self.batteryCharge.setup(info:$0)
            })
            .drive()
            .disposed(by: disposeBag)
        
        output.level
                .do(onNext: {
                    self.batterylevel.setup(info:$0)
                })
                .drive()
                .disposed(by: disposeBag)
                    
                    output.voltage
                    .do(onNext: {
                        self.voltage.setup(info:$0)
                    })
                    .drive()
                    .disposed(by: disposeBag)
        
    }
  
}




struct BatteryInfo{
    let title: String
    let description: String
}

