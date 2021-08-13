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
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    required init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("programmatic view")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

class DateCollectionView: UIView {
    
    private weak var delegate: UICollectionViewDelegate?
    private weak var datasource: UICollectionViewDataSource?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: DateCollectionViewCell.reuseIdentifier)
        cv.delegate = delegate
        cv.dataSource = datasource
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()

    required init(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.datasource = dataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
}
