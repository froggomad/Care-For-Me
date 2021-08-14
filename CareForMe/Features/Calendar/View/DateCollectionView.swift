//
//  DateCollectionView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/12/21.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: self)
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    private func setupViews() {
        backgroundColor = .clear
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            label.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
}

class DateCollectionView: UIView {
    
    private weak var delegate: UICollectionViewDelegate?
    private weak var datasource: UICollectionViewDataSource?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: DateCollectionViewCell.reuseIdentifier)
        cv.delegate = delegate
        cv.dataSource = datasource
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.allowsMultipleSelection = false
        return cv
    }()

    required init(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.datasource = dataSource
        setupViews()
    }
    
    private func setupViews() {
        addSubview(collectionView)
        constraints()
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
}
