//
//  SearchController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/28/21.
//

import UIKit

protocol SearchDelegate: UIViewController, UISearchResultsUpdating {
    /// force unwrapped due to init pattern
    var searchController: SearchController! { get set }
}

class SearchController: UISearchController {
    
    var searchSource: [String]
    
    init(delegate: SearchDelegate, searchArray: [String]) {
        self.searchSource = searchArray
        super.init(searchResultsController: delegate)
        searchResultsUpdater = delegate
        obscuresBackgroundDuringPresentation = false
        hidesNavigationBarDuringPresentation = false        
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
}


