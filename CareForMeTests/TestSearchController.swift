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
        let test = Test()
        test.foo()
        XCTAssertEqual(test.results, ["A"])
    }
    
}

class Test: UIViewController {
    var results: [String] = []
    
    func foo() {
        let searchController = SearchController(delegate: self)
        searchController.searchSource = ["A", "B", "C"]
        searchController.searchBar.text = "A"
        searchController.updateSearchResults(for: searchController)
    }
}

extension Test: SearchDelegate {
    func receiveSearchUpdate(_ results: [String]) {
        self.results = results
    }
}
