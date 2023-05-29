//
//  BatteryInfoView.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 29.05.2023.
//

import UIKit

class BatteryInfoView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "NO"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "NO"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup(info: BatteryInfo) {
        titleLabel.text = info.title
        descriptionLabel.text = info.description
    }
    
    private func setupLayout() {
        backgroundColor = .clear
        addSubviews(titleLabel, descriptionLabel)
       
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview()
            $0.height.equalTo(30)
            
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
//            $0.leading.equalToSuperview()
//            $0.height.equalTo(30)
            $0.leading.trailing.equalToSuperview()
            
        }
    }
    

}
