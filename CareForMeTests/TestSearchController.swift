//
//  TestSearchController.swift
//  CareForMeTests
//
//  Created by Kenneth Dubroff on 7/29/21.
//

import XCTest
@testable import CareForMe

class TestSearchController: XCTestCase {
    
    func testSearch() {
        let test = sut
        test.delegate.mockSearch()
        XCTAssertEqual(test.delegate.results, ["A"])
    }
    
    var sut: (delegate: SearchDelegateSpy, searchController: SearchController) {
        let delegate = SearchDelegateSpy()
        let searchController = SearchController(delegate: delegate, searchArray: ["A", "B", "C"])
        return (delegate, searchController)
    }
    
}

class SearchDelegateSpy: UIViewController {
    var results: [String] = []
    weak var searchController: SearchController!
    
    func mockSearch() {
        searchController!.searchBar.text = "A"
        searchController!.updateSearchResults(for: searchController!)
    }
}

extension SearchDelegateSpy: SearchDelegate {
    func receiveSearchUpdate(_ results: [String]) {
        self.results = results
    }
}
