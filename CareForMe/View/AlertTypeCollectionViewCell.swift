//
//  AlertTypeCollectionViewCell.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/15/21.
//

import UIKit

class AlertTypeCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlertTypeCollectionViewCell"
    
    var viewModel: AlertTypeViewModel? {
        didSet {
            imageView.image = viewModel?.image
            titleLabel.text = viewModel?.title
        }
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero, translates: false)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "pencil.circle.fill")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero, translates: false)
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .systemBackground
        setupViews()
    }
    
    private func setupViews() {
        if !subviews.contains(imageView) {
            addSubview(imageView)
        }
        
        if !subviews.contains(titleLabel) {
            addSubview(titleLabel)
        }
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor, constant: -20),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
}
