//
//  Searchable.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/3/21.
//

import UIKit

protocol Searchable: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    /// - false when the search controller is being dismissed
    /// - true when searchBar didBeginEditing
    var isSearching: Bool { get set }
    var updater: SearchableUpdatable? { get set }
}

class SearchDelegate: NSObject, Searchable {
    var isSearching: Bool = false
    weak var updater: SearchableUpdatable?
    var timer: Timer?
    
    func willDismissSearchController(_ searchController: UISearchController) {
        isSearching = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        timer?.invalidate()
        guard let updater = updater,
              isSearching
        else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            updater.search(with: searchController.searchBar.text ?? "")
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updater?.searchBarCancelButtonClicked()
    }
}

protocol SearchableUpdatable: AnyObject {
    var searcher: SearchDelegate { get set }
    var searchController: UISearchController { get set }
    func search(with text: String)
    func searchBarCancelButtonClicked()
}

