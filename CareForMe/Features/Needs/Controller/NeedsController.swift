//
//  NeedsController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/10/21.
//

import UIKit

protocol NeedsSearchDelegate: UIViewController {
    func receivedCategory(category: NeedsCategory)
    func searchButtonClicked()
    func cancelButtonClicked()
}

class NeedsController: SearchDelegate, SearchableUpdatable {
    
    enum Error: Swift.Error {
        case exists
        case notExists
    }
    
    typealias CategoryCompletion = (Result<NeedsCategory, Error>) -> Void
    typealias NeedCompletion = (Result<Need, Error>) -> Void
    
    var searcher: SearchDelegate = SearchDelegate()
    lazy var searchController: UISearchController = .init(with: self)
    weak var delegate: NeedsSearchDelegate?
    var searchCategories: [NeedsCategory] = []
    var categories: [NeedsCategory] = []
    var filteredCategories: [NeedsCategory] = []
    var cellSelectDelegate: CareAlertSelectionDelegate?
    
    static var shared = NeedsController()
    
    private override init() {
        super.init()
        searcher = self
        searchController = .init(with: searcher)
        self.searcher.updater = self
    }
    
    func addCategory(_ category: NeedsCategory, completion: @escaping CategoryCompletion) {
        guard !searchCategories.contains(category) else {
            completion(.failure(.exists))
            return
        }
        searchCategories.append(category)
        copyCategory(category: category)
        completion(.success(category))
    }
    
    func editCategory(_ oldCategory: NeedsCategory, title: String, completion: @escaping CategoryCompletion) {
        guard let categoryIndex = searchCategories.firstIndex(of: oldCategory) else {
            addCategory(oldCategory, completion: completion)
            return
        }
        self.searchCategories[categoryIndex].title = title
        
        if let searchIndex = categories.firstIndex(of: oldCategory) {
            categories[searchIndex].title = title
        }
        
        completion(.success(self.searchCategories[categoryIndex]))
    }
    
    func deleteCategory(_ category: NeedsCategory, completion: @escaping CategoryCompletion) {
        guard let categoryIndex = searchCategories.firstIndex(of: category) else {
            completion(.failure(.notExists))
            return
        }
        searchCategories.remove(at: categoryIndex)
        
        if let searchIndex = searchCategories.firstIndex(of: category) {
            categories.remove(at: searchIndex)
        }
        
        completion(.success(category))
    }
    
    // MARK: - Needs -
    /// add a need to an existing category
    func addNeed(_ need: Need, to category: NeedsCategory, completion: @escaping NeedCompletion) {
        if let categoryIndex = searchCategories.firstIndex(of: category) {
            self.searchCategories[categoryIndex].addNeed(need)
            
            if let searchIndex = categories.firstIndex(of: category) {
                categories[searchIndex].addNeed(need)
            }
            completion(.success(need))
        } else {
            completion(.failure(.notExists))
        }
    }
    
    func editNeed(_ oldNeed: Need, with newNeed: Need, in category: NeedsCategory, completion: @escaping NeedCompletion) {
        
        guard let categoryIndex = searchCategories.firstIndex(of: category),
              let needIndex = searchCategories[categoryIndex].needs.firstIndex(of: oldNeed)
        else {
            completion(.failure(.notExists))
            return
        }
        
        searchCategories[categoryIndex].alerts[needIndex] = newNeed
        
        if let searchIndex = categories.firstIndex(of: category) {
            categories[searchIndex].alerts[needIndex] = newNeed
        }
        
        completion(.success(newNeed))
    }
    
    func searchBarCancelButtonClicked() {
        searchCategories = categories
        delegate?.cancelButtonClicked()
    }
    
    func search(with text: String) {
        defer { delegate?.searchButtonClicked() }
        
        guard !text.isEmpty else {
            searchCategories = categories
            return
        }
        let filteredCategories = searchCategories.filter{ $0.title.contains(text) || $0.needs.filter { $0.title.lowercased().contains(text.lowercased()) }.isEmpty == false}
        searchCategories = filteredCategories
    }
    
    private func copyCategory(category: NeedsCategory) {
        
        self.categories.append(
            NeedsCategory(id: category.id,
                          title: category.title,
                          alerts: category.alerts,
                          color: category.color)
        )
        
    }
    
}

extension NeedsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AlertCategoryTableViewCell(alertCategory: searchCategories[indexPath.row], cellSelectDelegate: cellSelectDelegate)
        return cell
    }
}
