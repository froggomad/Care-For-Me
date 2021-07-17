//
//  AlertCategoryTableViewCell.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/16/21.
//

import UIKit

class AlertCategoryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "AlertCategoryTableViewCell"
    var cellSelectDelegate: CareAlertSelectionDelegate?
    
    var category: AlertCategorizable! {
        didSet {
            setupViews()
        }
    }
    
    lazy var parentStack: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [contentStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.alignment = .top
        return stackView
    }()
    
    lazy var contentStack: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [collectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var collectionView: CareCollectionView = {
        let cv = CareCollectionView(alertType: category)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.cellSelectDelegate = cellSelectDelegate
        cv.heightAnchor.constraint(equalToConstant: CareCollectionView.CareTypeLayout.heightConstant).isActive = true
        return cv
    }()
    
    private func setupViews() {
        collectionView.alertType = category
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupViews()
    }
    
    init(alertCategory: AlertCategorizable, cellSelectDelegate: CareAlertSelectionDelegate? = nil) {
        self.category = alertCategory
        self.cellSelectDelegate = cellSelectDelegate
        super.init(style: .default, reuseIdentifier: Self.reuseIdentifier)
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: Self.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
}
