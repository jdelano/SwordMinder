//
//  Array+ExtensionsTests.swift
//  SwordMinderTests
//
//  Created by John Delano on 12/5/22.
//

import XCTest
@testable import SwordMinder

final class Array_ExtensionsTests: XCTestCase {

    struct Test : Hashable {
        var id = UUID()
        var text: String
    }
    
    func testArrayRemoveDuplicates() throws {
        var tests = [Test(text: "HI"), Test(text: "HI"), Test(text: "HELLO"), Test(text: "HI")]
        print(tests.removingDuplicates(for: { element in
            element.text
        }))
    }
    
    
}
