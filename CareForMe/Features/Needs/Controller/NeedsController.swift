//
//  NeedsController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/10/21.
//

import Foundation

class NeedsController {
    var categories: [NeedsCategory] = []
    
    @discardableResult func addCategory(_ category: NeedsCategory) -> Bool {
        guard !categories.contains(category) else { return false }
        categories.append(category)
        return true
    }
    
    @discardableResult func editCategory(_ oldCategory: NeedsCategory, title: String) -> Bool {
        guard let categoryIndex = categories.firstIndex(of: oldCategory) else { return false }
        self.categories[categoryIndex].title = title
        return true
    }
    
    @discardableResult func deleteCategory(_ category: NeedsCategory) -> Bool {
        guard let categoryIndex = categories.firstIndex(of: category) else { return false }
        categories.remove(at: categoryIndex)
        return true
    }
    
    // MARK: - Needs -
    /// add a need to an existing category
    /// - Returns: true if the add succeeded, false if it failed
    @discardableResult func addNeed(_ need: Need, to category: NeedsCategory) -> Bool {
        
        if let categoryIndex = categories.firstIndex(of: category) {
            return self.categories[categoryIndex].addNeed(need)            
        } else { return false }
        
    }
    
    @discardableResult func editNeed(_ oldNeed: Need, with newNeed: Need, in category: NeedsCategory) -> Bool {
        
        guard let categoryIndex = categories.firstIndex(of: category),
              let needIndex = categories[categoryIndex].needs.firstIndex(of: oldNeed)
        else { return false }
        
        categories[categoryIndex].needs[needIndex] = newNeed
        return true
        
    }
    
}
