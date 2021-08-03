//
//  UISearchController+initWithDelegate.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/3/21.
//

import UIKit

typealias SearchDelegate = UIViewController & UISearchBarDelegate & UISearchControllerDelegate & UISearchResultsUpdating

extension UISearchController {
    convenience init(with delegate: SearchDelegate) {
        self.init()
        definesPresentationContext = false
        obscuresBackgroundDuringPresentation = false
        hidesNavigationBarDuringPresentation = false
        searchResultsUpdater = delegate
        searchBar.delegate = delegate
        self.delegate = delegate
        searchBar.searchBarStyle = .minimal
    }
}
