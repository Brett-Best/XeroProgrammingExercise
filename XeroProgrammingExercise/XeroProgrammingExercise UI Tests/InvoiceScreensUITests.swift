//
//  InvoiceScreensUITests.swift
//  XeroProgrammingExerciseUITests
//
//  Created by Brett Best on 6/8/2023.
//  Copyright © 2023 Xero Limited. All rights reserved.
//

import XCTest

final class InvoiceScreensUITests: XCTestCase {
  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
  }

  func testSelectingInvoiceFromList() throws {
    let app = XCUIApplication()
    app.launch()

    XCTAssertEqual(app.cells.count, 3)
    app.cells.firstMatch.tap()

    XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS '41.32'")).element.exists)
  }
}
