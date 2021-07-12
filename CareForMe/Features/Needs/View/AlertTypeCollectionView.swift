//
//  CareTypeCollectionView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/15/21.
//

import UIKit
import BadgeGenerator

class AlertTypeCollectionView: UIView {
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, collectionView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 10
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .preferredFont(forTextStyle: .title1)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: Layout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AlertTypeCollectionViewCell.self, forCellWithReuseIdentifier: AlertTypeCollectionViewCell.identifier)
        return collectionView
    }()
    
    /// for didSelectItem
    weak var cellSelectDelegate: CareTypeCollectionViewDelegate?
    
    var alertType: AlertCategorizable? {
        didSet {
            guard let alertType = alertType else { return }
            
            titleLabel.text = alertType.title
            collectionView.backgroundColor = alertType.color.uiColor
        }
    }
    
    /// programmatic init
    init(alertType: AlertCategorizable) {
        super.init(frame: .zero)
        defer { self.alertType = alertType }
        self.translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
}

private extension AlertTypeCollectionView {
    private func setupViews() {
        backgroundColor = .systemBackground
        addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension AlertTypeCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        alertType?.alerts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlertTypeCollectionViewCell.identifier, for: indexPath) as! AlertTypeCollectionViewCell
        
        cell.viewModel = alertType?.alerts[indexPath.item].viewModel
        return cell
    }
    
}

extension AlertTypeCollectionView {
    
    class Layout: UICollectionViewFlowLayout {
        static let heightConstant: CGFloat = 150
        
        override func prepare() {
            super.prepare()
            guard let collectionView = collectionView else { return }
            // TODO: why -13 to make the size even?
            itemSize = CGSize(width: collectionView.frame.width / 3 - 13, height: Self.heightConstant - 40)
            scrollDirection = .horizontal
            sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
    }
    
}

extension AlertTypeCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let alertType = alertType else { return }
        cellSelectDelegate?.didSelect(alertType.alerts[indexPath.item])
    }
}
