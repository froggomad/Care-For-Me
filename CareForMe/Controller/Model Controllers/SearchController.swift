//
//  SearchController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/28/21.
//

import UIKit

protocol SearchDelegate: UIViewController, UISearchControllerDelegate {
    /// force unwrapped due to init pattern
    var searchController: SearchController! { get set }
    func receiveSearchUpdate(_ results: [String])
}

class SearchController: UISearchController {
    
    var searchSource: [String]
    weak var searchDelegate: SearchDelegate!
    
    init(delegate: SearchDelegate, searchArray: [String]) {
        self.searchSource = searchArray
        super.init(searchResultsController: delegate)
        self.searchDelegate = delegate
        self.delegate = delegate
        delegate.searchController = self
        obscuresBackgroundDuringPresentation = false
        hidesNavigationBarDuringPresentation = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchBar.text else { return }
        
        let results = searchSource.filter { $0.contains(text) }
        searchDelegate?.receiveSearchUpdate(results)
    }
}
