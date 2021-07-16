//
//  NeedsController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/10/21.
//

import Foundation

class NeedsController {
    enum Error: Swift.Error {
        case exists
        case notExists
    }
    
    typealias CategoryCompletion = (Result<NeedsCategory, Error>) -> Void
    typealias NeedCompletion = (Result<Need, Error>) -> Void
    
    var categories: [NeedsCategory] = []
    
    func addCategory(_ category: NeedsCategory, completion: @escaping CategoryCompletion) {
        guard !categories.contains(category) else {
            completion(.failure(.exists))
            return
        }
        categories.append(category)
        completion(.success(category))
    }
    
    func editCategory(_ oldCategory: NeedsCategory, title: String, completion: @escaping CategoryCompletion) {
        guard let categoryIndex = categories.firstIndex(of: oldCategory) else {
            completion(.failure(.notExists))
            return
        }
        self.categories[categoryIndex].title = title
        completion(.success(self.categories[categoryIndex]))
    }
    
    func deleteCategory(_ category: NeedsCategory, completion: @escaping CategoryCompletion) {
        guard let categoryIndex = categories.firstIndex(of: category) else {
            completion(.failure(.notExists))
            return
        }
        categories.remove(at: categoryIndex)
        completion(.success(category))
    }
    
    // MARK: - Needs -
    /// add a need to an existing category
    func addNeed(_ need: Need, to category: NeedsCategory, completion: @escaping NeedCompletion) {
        if let categoryIndex = categories.firstIndex(of: category) {
            self.categories[categoryIndex].addNeed(need)
            completion(.success(need))
        } else {
            completion(.failure(.notExists))
        }
    }
    
    func editNeed(_ oldNeed: Need, with newNeed: Need, in category: NeedsCategory, completion: @escaping NeedCompletion) {
        
        guard let categoryIndex = categories.firstIndex(of: category),
              let needIndex = categories[categoryIndex].needs.firstIndex(of: oldNeed)
        else {
            completion(.failure(.notExists))
            return
        }
        
        categories[categoryIndex].alerts[needIndex] = newNeed
        completion(.success(newNeed))
    }
    
}
