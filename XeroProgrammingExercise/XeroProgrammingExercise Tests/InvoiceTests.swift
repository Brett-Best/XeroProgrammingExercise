//
//  InvoiceTests.swift
//  XeroProgrammingExerciseTests
//
//  Created by Brett Best on 6/8/2023.
//  Copyright © 2023 Xero Limited. All rights reserved.
//

import XCTest
@testable import XeroProgrammingExercise

final class InvoiceTests: XCTestCase {
  static let mangosteenSmallInvoiceLine = InvoiceLine(id: 1, description: "Mangosteen (small)", quantity: 12, cost: 50)
  static let mangosteenMediumInvoiceLine = InvoiceLine(id: 2, description: "Mangosteen (medium)", quantity: 8, cost: 40)
  static let mangosteenLargeInvoiceLine = InvoiceLine(id: 3, description: "Mangosteen (large)", quantity: 4, cost: 30)

  func testInitializerWithNoDefaultParameters() {
    let date = Date().addingTimeInterval(-60 * 60 * 24)
    let lineItems = [Self.mangosteenLargeInvoiceLine]
    let invoice1 = Invoice(id: 1, date: date, lineItems: lineItems)

    XCTAssertEqual(invoice1.id, 1)
    XCTAssertEqual(invoice1.date, date)
    XCTAssertEqual(invoice1.lineItems, lineItems)
  }

  func testInitializerWithDefaultParameters() {
    let invoice1 = Invoice(id: 1)

    XCTAssertEqual(invoice1.id, 1)
    XCTAssertEqual(invoice1.date.timeIntervalSince1970, Date().timeIntervalSince1970, accuracy: 1)
    XCTAssertTrue(invoice1.lineItems.isEmpty)
  }

  func testClone() throws {
    let invoice1 = Invoice(id: 1, lineItems: [Self.mangosteenLargeInvoiceLine])

    var invoice2 = invoice1.clone()
    try invoice2.removeInvoiceLine(withId: Self.mangosteenLargeInvoiceLine.id)

    XCTAssertFalse(invoice1.lineItems.isEmpty)
    XCTAssertTrue(invoice2.lineItems.isEmpty)
  }

  func testAddInvoiceLineSucceeds() throws {
    var invoice1 = Invoice(id: 1)
    try invoice1.addInvoiceLine(Self.mangosteenLargeInvoiceLine)

    XCTAssertEqual(invoice1.lineItems.first, Self.mangosteenLargeInvoiceLine)
  }

  func testAddInvoiceLineThrowsOnDuplicateItem() {
    var invoice1 = Invoice(id: 1, lineItems: [Self.mangosteenLargeInvoiceLine])

    XCTAssertThrowsError(try invoice1.addInvoiceLine(Self.mangosteenLargeInvoiceLine)) { error in
      guard case Invoice.Error.invoiceItemExistsAlready = error else {
        XCTFail("Expected error to be: \(Invoice.Error.invoiceItemExistsAlready)")
        return
      }
    }
  }

  func testRemoveInvoiceSucceeds() throws {
    var invoice1 = Invoice(id: 1, lineItems: [Self.mangosteenLargeInvoiceLine, Self.mangosteenSmallInvoiceLine])

    try invoice1.removeInvoiceLine(withId: Self.mangosteenLargeInvoiceLine.id)

    XCTAssertEqual(invoice1.lineItems.first, Self.mangosteenSmallInvoiceLine)
    XCTAssertEqual(invoice1.lineItems.count, 1)
  }

  func testRemoveInvoiceThrowsOnUnknownInvoiceLineId() throws {
    var invoice1 = Invoice(id: 1)

    XCTAssertThrowsError(try invoice1.removeInvoiceLine(withId: 20)) { error in
      guard case Invoice.Error.invoiceItemNotFound = error else {
        XCTFail("Expected error to be: \(Invoice.Error.invoiceItemNotFound)")
        return
      }
    }
  }

  func testOrderLineItemsByIdSucceeds() {
    var invoice1 = Invoice(id: 1, lineItems: [Self.mangosteenLargeInvoiceLine, Self.mangosteenSmallInvoiceLine, Self.mangosteenMediumInvoiceLine])
    invoice1.orderLineItemsById()

    XCTAssertEqual(invoice1.lineItems, [Self.mangosteenSmallInvoiceLine, Self.mangosteenMediumInvoiceLine, Self.mangosteenLargeInvoiceLine])
  }

  func testLineItemsPrefixSucceeds() {
    let invoice1 = Invoice(id: 1, lineItems: [Self.mangosteenLargeInvoiceLine, Self.mangosteenSmallInvoiceLine, Self.mangosteenMediumInvoiceLine])

    XCTAssertEqual(Array(invoice1.lineItems(maxLength: 2)), [Self.mangosteenLargeInvoiceLine, Self.mangosteenSmallInvoiceLine])
  }

  func testLineItemsPrefixWhenMaxLengthIsGreaterThanLineItems() {
    let invoice1 = Invoice(id: 1, lineItems: [])

    XCTAssertTrue(invoice1.lineItems(maxLength: 999).isEmpty)
  }

  func testMergeInvoicesSucceeds() throws {
    var invoice1 = Invoice(id: 1, lineItems: [Self.mangosteenMediumInvoiceLine, Self.mangosteenSmallInvoiceLine])
    let invoice2 = Invoice(id: 2, lineItems: [Self.mangosteenLargeInvoiceLine])

    try invoice1.mergeInvoices(sourceInvoice: invoice2)

    XCTAssertEqual(invoice1.lineItems, [Self.mangosteenMediumInvoiceLine, Self.mangosteenSmallInvoiceLine, Self.mangosteenLargeInvoiceLine])
  }

  func testMergeInvoicesThrowsWhenConflictsExist() {
    var invoice1 = Invoice(id: 1, lineItems: [Self.mangosteenMediumInvoiceLine, Self.mangosteenSmallInvoiceLine])
    let invoice2 = Invoice(id: 2, lineItems: [Self.mangosteenSmallInvoiceLine])

    XCTAssertThrowsError(try invoice1.mergeInvoices(sourceInvoice: invoice2)) { error in
      guard case Invoice.Error.invoiceMergeConflict = error else {
        XCTFail("Expected error to be: \(Invoice.Error.invoiceMergeConflict)")
        return
      }
    }
  }

  func testRemovingItemsFromAnExistingInvoice() {
    var invoice1 = Invoice(id: 1, lineItems: [Self.mangosteenMediumInvoiceLine, Self.mangosteenSmallInvoiceLine])
    let invoice2 = Invoice(id: 2, lineItems: [Self.mangosteenSmallInvoiceLine])

    invoice1.removeItems(from: invoice2)

    XCTAssertEqual(invoice1.lineItems, [Self.mangosteenMediumInvoiceLine])
  }

  func testTotalOfInvoiceWithNoItems() {
    let invoice1 = Invoice(id: 1)
    XCTAssertEqual(invoice1.total, 0)
  }

  func testTotalOfInvoiceWithItems() {
    let invoice1 = Invoice(id: 1, lineItems: [Self.mangosteenMediumInvoiceLine, Self.mangosteenLargeInvoiceLine])
    XCTAssertEqual(invoice1.total, 440)
  }

  func testTotalAfterInvoiceIsAltered() throws {
    var invoice1 = Invoice(id: 1, lineItems: [Self.mangosteenMediumInvoiceLine, Self.mangosteenLargeInvoiceLine])

    try invoice1.removeInvoiceLine(withId: 2)
    try invoice1.addInvoiceLine(Self.mangosteenSmallInvoiceLine)
    try invoice1.removeInvoiceLine(withId: 3)

    XCTAssertEqual(invoice1.total, 600)
  }

  func testFormattedInvoice() {
    let date = Date(timeIntervalSince1970: 1_691_327_383) // 6th August 2023, ~11PM, Australia/Melbourne
    let invoice10 = Invoice(id: 10, date: date, lineItems: [Self.mangosteenMediumInvoiceLine, Self.mangosteenLargeInvoiceLine])

    XCTAssertEqual(invoice10.formatted(), "Invoice Number: 10, InvoiceDate: 6/8/2023, LineItemCount: 2")
  }
}
