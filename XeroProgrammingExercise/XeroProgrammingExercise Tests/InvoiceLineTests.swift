//
//  InvoiceLineTests.swift
//  XeroProgrammingExerciseTests
//
//  Created by Brett Best on 6/8/2023.
//  Copyright © 2023 Xero Limited. All rights reserved.
//

import XCTest
@testable import XeroProgrammingExercise

final class InvoiceLineTests: XCTestCase {
  func testTotal() {
    XCTAssertEqual(InvoiceLine(id: 5, description: "Blueberries", quantity: 4, cost: 12.75).totalCost, 51)
  }
}
