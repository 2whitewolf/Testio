//
//  SubscriptionViewController.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 29.05.2023.
//


import UIKit
import Foundation
import RxCocoa
import RxSwift
import SnapKit



final class SubscriptionViewController: UIViewController {
//
    //MARK: UIElements
    private lazy var restoreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Restore", for: .normal)
        button.rx.tap.bind {
          
        }.disposed(by: disposeBag  )

        return button
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = .black
//        button.setTitle("back", for: .normal)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.rx.tap.bind {
           
           
            self.dismiss(animated: true, completion: nil)
        }.disposed(by:  disposeBag)
       
        return button
    }()

//    return button
//  }()
//    private lazy var crownImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = #imageLiteral(resourceName: "launch")
//
//        return imageView
//    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 34, weight: .semibold)
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.text = "Testio"

        return label
    }()
    
    private lazy var imgPremium: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "purchase")
        return imageView
    }()
    

    
    private lazy var firstOffer = OfferView(title: "Unlimited tests")
    private lazy var secondOffer = OfferView(title: "Remove ads")
    private lazy var thirdOffer = OfferView(title: "Unlock USSD Codes")




    private lazy var activateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appBlue
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Continue", for: .normal)
        return button
    }()

    
    
    
  
    private lazy var offerCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = .init(width: UIScreen.screenWidth * 0.35, height:  UIScreen.screenWidth * 0.3)
        collectionViewLayout.minimumLineSpacing = 15
        collectionViewLayout.minimumInteritemSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
//        collectionView.isScrollEnabled = true
        collectionView.bounces = false
        collectionView.register(OfferCollectionViewCell.self, forCellWithReuseIdentifier: OfferCollectionViewCell.nibIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    //MARK: -Variables
   
    private var products: [Product] = [Product(price: "3.00", duration: "3 weeks", notes: "3 DAYS TRIAL"),Product(price: "3.00", duration: "3 weeks", notes: "3 DAYS TRIAL")]
    private var selectedProduct: Product?
    private var disposeBag =  DisposeBag()

    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
       
    }

    //MARK: -Functions
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(restoreButton)
        view.addSubview(closeButton)
        view.addSubviews(imgPremium,  firstOffer, secondOffer,thirdOffer, offerCollectionView,activateButton)
        
      

        firstOffer.snp.makeConstraints {
            $0.centerY.equalTo(imgPremium.snp.bottom).offset(21)
            $0.leading.equalTo(imgPremium.snp.leading).offset(40)
        }
        secondOffer.snp.makeConstraints {
            $0.centerY.equalTo(firstOffer.snp.bottom).offset(10)
            $0.leading.equalTo(firstOffer.snp.leading)
        }
        thirdOffer.snp.makeConstraints {
            $0.centerY.equalTo(secondOffer.snp.bottom).offset(10)
            $0.leading.equalTo(firstOffer.snp.leading)

        }

        imgPremium.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(restoreButton.snp.bottom).offset(20)
            $0.size.equalTo(UIScreen.screenHeight * 0.32)

        }
        restoreButton.snp.makeConstraints {

            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalTo(closeButton)

        }

        closeButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(12)
            $0.top.equalToSuperview().offset(40)
            $0.size.equalTo(40)
        }

        offerCollectionView.snp.makeConstraints { make in
            make.top.equalTo(thirdOffer.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.screenWidth * 0.74)

             make.height.equalTo(150)
        }
//
        activateButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.trailing.equalToSuperview().inset(20)
               $0.centerX.equalToSuperview()
            
            $0.height.equalTo(50)
              }
//

    }
   

 
  
}

//MARK: -Extensions
extension SubscriptionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OfferCollectionViewCell.nibIdentifier, for: indexPath) as! OfferCollectionViewCell
        cell.setup(product: products[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProduct = products[indexPath.row]
    }
}




struct Product{
    let id = UUID()
    let price: String
    let duration: String
    let notes: String
}
