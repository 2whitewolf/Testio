//
//  TestsViewController.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 26.05.2023.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import Then
import SnapKit

class TestsViewController: UIViewController {
    
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<RegularSectionModel>
    
    private lazy var premiumButton = UIButton().then{ button in
        button.setImage(UIImage(systemName: "line.3.horizontal")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        button.rx.tap.bind(onNext: {
            let nav = UINavigationController()
            let vc = SubscriptionViewController()
            nav.viewControllers = [vc]
            nav.modalPresentationStyle = .fullScreen
            self.navigationController?.present(nav, animated: true)

        })
        .disposed(by: disposeBag)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: UICollectionViewLayout()).then { collectionView in
        collectionView.collectionViewLayout = self.compositionalLayout
        collectionView.register(SelectionListCell.self, forCellWithReuseIdentifier: SelectionListCell.reuseIdentifier)
        collectionView.allowsSelection = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
    }
    
    private let viewModel: TestsViewModel
    private var disposeBag: DisposeBag
    
    init() {
        viewModel = TestsViewModel()
        disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindingSetup()
        viewSetup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           
        disposeBag = DisposeBag()
       }
    
    private func bindingSetup() {
        let viewWillAppearTrigger = rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let selectedModel = collectionView.rx
            .modelSelected(RegularSectionItem.self)
            .asDriver()
        
        let dataSource = makeDataSource()
        
        
        let input = TestsViewModel.Input(
            viewWillAppearTrigger: viewWillAppearTrigger,
            selectedModel: selectedModel
        )
        
        let output = viewModel.transform(input: input, disposeBag: self.disposeBag)
        
        output.sections
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        output.nextPage
            .drive(onNext: { [weak self] model in
                if let model = model {
                    self?.openTest(model: model)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    
    private func viewSetup() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        
        view.addSubview(premiumButton)
        
        premiumButton.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(50)
            make.leading.equalToSuperview().offset(12)
            make.size.equalTo(50)
            
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
//            make.top.equalTo(premiumButton.snp.bottom).offset(40)
//            make.bottom.equalToSuperview()
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(400)
        }
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.collectionView.deselectItem(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func openTest(model: TestVM) {
        let test = model.model
        let nav = UINavigationController()
        let vc = TestViewController(test: test)
        nav.viewControllers = [vc]
        nav.modalPresentationStyle = .fullScreen
        navigationController?.present(nav, animated: true)
        
    }
    
    
    
    
    private func makeDataSource() -> DataSource {
        let cellConfiguration: DataSource.ConfigureCell = { dataSource, collectionView, indexPath, item in
            switch item {
            case .SelectionItemWithId(icon: let icon, title: let title, selected: let selected, passed: let passed, id: _):
                //                let cell = collectionView.dequeueReusableCell(withIdentifier: SelectionListCell.identifier) as! SelectionListCell
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectionListCell.reuseIdentifier,
                                                              for: indexPath) as! SelectionListCell
                cell.configureWith(title: title, icon: icon, selected: selected, passed: passed)
                return cell
            default:
                fatalError()
            }
        }
        
        return DataSource(configureCell: cellConfiguration)
    }
    
    
    private let compositionalLayout = UICollectionViewCompositionalLayout { sectionIndex, environment in
        //      guard let sectionType = Section(rawValue: sectionIndex) else {
        //        return nil
        //      }
        
        let columnCount = 2
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columnCount)
        
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 6
        section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        return section
    }
}


struct RegularSectionModel {
    var header: String? = nil
    var footer: String? = nil
    var items: [RegularSectionItem]
}

extension RegularSectionModel: SectionModelType {
    typealias Item = RegularSectionItem
    
    init(original: RegularSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

enum RegularSectionItem {
    case SelectionItemWithId(
        icon: UIImage?,
        title: String?,
        selected: Driver<Bool>,
        passed: Driver<Bool>,
        id: UUID
    )
}


