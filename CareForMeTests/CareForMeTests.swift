//
//  CareForMeTests.swift
//  CareForMeTests
//
//  Created by Kenneth Dubroff on 6/15/21.
//

import XCTest
@testable import CareForMe

class CareForMeTests: XCTestCase {

    func testCategory_andAlert_dontRetain() {
        let alertCategory = AlertCategory(id: UUID(), color: UIColor.NamedColor.red.rawValue, type: "")
        
        let alert = CareAlertType(id: UUID(),
                              category: alertCategory,
                              title: "",
                              message: "",
                              image: UIImage().pngData() ?? Data())
        
        alertCategory.alerts = [alert]
        
        assertNoMemoryLeak(alertCategory)
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