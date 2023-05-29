//
//  SelectionListCell.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 26.05.2023.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa


class SelectionListCell: UICollectionViewCell {
    
    private let iconView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then { label in
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .medium)
    }
    
    private let cardView = UIView().then { view in
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.gray.cgColor
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 4
        //          view.backgroundColor = .blue
    }
    private let checkMarkImageView = UIImageView().then { imageView in
        let image = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysOriginal)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
    }
    
    //    private let labelsContainer = UIView()
    // MARK: - Properties
    static let reuseIdentifier = "SelectionListCell"
    
    private var disposeBag = DisposeBag()
    private let imageSize = 46.0
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //      super.setSelected(selected, animated: animated)
    //    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
    }
    
    // MARK: - Methods
    private func viewSetup() {
        
        
        backgroundColor = .clear
        
        contentView.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(iconView)
        cardView.addSubview(checkMarkImageView)
        
        layoutSetup()
    }
    
    private func layoutSetup() {
        cardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(6)
            //            make.width.equalTo(UIScreen.screenWidth * 0.4)
            //            make.height.equalTo(100)
        }
        
        
        checkMarkImageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            //          make.trailing.equalTo(iconView.snp.trailing).inset(-20)
            make.width.height.equalTo(18)
        }
        
        
        iconView.snp.remakeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.size.equalTo(32)
            //          make..equalToSuperview().inset(12)
        }
        titleLabel.snp.makeConstraints{ make in
            make.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(12)
        }
    }
    
    func configureWith(title: String?, icon: UIImage?, selected: Driver<Bool>, passed: Driver<Bool>) {
        titleLabel.text = title
        iconView.image = icon
        //      iconBackgroundView.backgroundColor = iconBackground
        
        
        selected
            .map { $0 ? UIColor.appBlue.cgColor : UIColor.white.cgColor}
            .drive(cardView.layer.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        
        passed
            .map { $0 ?  UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysOriginal) :  UIImage(systemName: "xmark")?.withRenderingMode(.alwaysOriginal)}
            .drive(checkMarkImageView.rx.image)
            .disposed(by: disposeBag)
        
        passed
            .map { $0 ? UIColor.appBlue : UIColor.red }
            .drive(checkMarkImageView.rx.tintColor)
            .disposed(by: disposeBag)
        
        selected
            .map { $0 ? UIColor.white: UIColor.appBlue }
            .drive(titleLabel.rx.textColor)
            .disposed(by: disposeBag)
    }
}


