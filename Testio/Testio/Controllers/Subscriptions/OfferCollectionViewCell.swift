//
//  OfferCollectionViewCell.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 29.05.2023.
//

import UIKit
import SnapKit

final class OfferCollectionViewCell: UICollectionViewCell {
    
    
    static let nibIdentifier = "offercell"
    
    
    
    private lazy var dot: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.appBlue)
        return imageView
    }()
    
    //MARK: -UIElements
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .semibold )
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
      
        return label
    }()
    
    private lazy var centerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular )
        label.textAlignment = .center
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlue
        label.font = .systemFont(ofSize: 20, weight: .regular )
        label.textAlignment = .center
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private lazy var autoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .semibold )
        label.text = "Auto renewable"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    private lazy var selectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
//        imageView.image = "unselectedIcon".image
       
        return imageView
    }()
    
    //MARK: -Variables
    private var product: Product? {
        didSet {
           
            topLabel.text = "$ \(product!.price)"
            centerLabel.text = product!.duration
            bottomLabel.text = product?.notes
           
        }
    }
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.appBlue.withAlphaComponent(0.4) : .white
            topLabel.textColor = .black
            bottomLabel.textColor = .appBlue
            dot.tintColor = isSelected ? .white : .blue
//            layer.borderColor = isSelected ? UIColor.appBlue.cgColor :  UIColor.gray.cgColor
        }
    }
    
    //MARK: -Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = .red
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Functions
    private func setupLayout() {
//        backgroundColor = .red
       layer.cornerRadius = 14
        clipsToBounds = true
        layer.masksToBounds = true
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOpacity = 0.5
//        view.layer.shadowOffset = CGSize(width: 2, height: 2)
//        view.layer.shadowRadius = 4
        
        addSubviews(dot,topLabel,centerLabel, bottomLabel)
        dot.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.size.equalTo(20)
        }
        topLabel.snp.makeConstraints {
            $0.top.equalTo(dot.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(22)
        }
        centerLabel.snp.makeConstraints{ make in
            make.top.equalTo(topLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        bottomLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-5)
            $0.centerX.equalToSuperview()
            
        }
//        autoLabel.snp.makeConstraints{
//            $0.centerY.equalTo(bottomLabel)
//            $0.leading.equalTo(bottomLabel.snp.trailing).offset(5.resized())
//        }
//
            }
    
    func setup(product: Product) {
        self.product = product
    }
}





final class OfferView: UIView {

    //MARK: -UIElements
    private lazy var dotView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.appBlue)
        
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlue
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    //MARK: -Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    convenience init(title: String) {
        self.init()
        
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Functions
    private func setupLayout() {
        backgroundColor = .clear
        addSubviews(dotView, titleLabel)
        dotView.snp.makeConstraints {
            $0.centerY.equalToSuperview()//.offset(35.resized(.width))
            $0.leading.equalToSuperview()
            $0.size.equalTo(20)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(dotView.snp.trailing).offset(15)
            $0.centerY.equalToSuperview()
            $0.height.top.equalTo(18)
      }
    }
}


