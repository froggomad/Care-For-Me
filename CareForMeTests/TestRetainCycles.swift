//
//  CareForMeTests.swift
//  CareForMeTests
//
//  Created by Kenneth Dubroff on 6/15/21.
//

import XCTest
@testable import CareForMe

class TestRetainCycles: XCTestCase {

    func testCategory_andAlert_dontRetain() {
        let alertCategory = AlertCategory(id: UUID(), color: .init(uiColor: .named(.highlight)), type: "")
        
        let alert = CareAlertType(id: UUID(),
                                  category: alertCategory,
                                  stockPhotoName: .ambulance,
                                  title: "",
                                  message: "")
        
        alertCategory.alerts = [alert]
        
        assertNoMemoryLeak(alertCategory)
    }
    
    func testStatusTextField_andDelegate_dontRetain() {
        let textField = StatusTextField<Foo>(textFieldType: .email, type: .information)
        let foo = Foo(textFields: [textField])
        
        XCTAssertNotNil(textField.statusTextFieldDelegate)
        assertNoMemoryLeak(foo)
        assertNoMemoryLeak(textField)
    }
    
    func testStatusTextFieldDelegate_NotNil_AfterInit() {
        let passwordTextField = StatusTextField<PasswordStatusTextFieldDelegate>(textFieldType: .email, type: .information)
        let delegate = PasswordStatusTextFieldDelegate(textFields: [passwordTextField])
        XCTAssertEqual(delegate.textFields.count, 1)
        XCTAssertNotNil(passwordTextField.statusTextFieldDelegate)
    }
    
    func testSearcher_andDelegate_dontRetain() {
        let delegate = SearchDelegate()
        let searchableUpdateSpy = SearchableUpdatableSpy(with: delegate)
        assertNoMemoryLeak(searchableUpdateSpy)
        assertNoMemoryLeak(delegate)
    }
    
    func testOnboard_andView_dontRetain() {
        let vc = OnboardingLinkVC(id: 2)
        let view = vc.instructionView
        assertNoMemoryLeak(view)
        assertNoMemoryLeak(vc)
    }

}

extension XCTestCase {
    // Credit: https://www.essentialdeveloper.com/
    func assertNoMemoryLeak(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential retain cycle.", file: file, line: line)
        }
    }
}

class SearchableUpdatableSpy: NSObject, SearchableUpdatable {
    func searchBarCancelButtonClicked() {
        
    }
    
    var searcher: SearchDelegate
    
    init(with delegate: SearchDelegate) {
        self.searcher = delegate
        self.searchController = .init(with: delegate)
        super.init()
        searcher.updater = self
    }
    
    var searchController: UISearchController
    
    func search(with text: String) {
        
    }
}
