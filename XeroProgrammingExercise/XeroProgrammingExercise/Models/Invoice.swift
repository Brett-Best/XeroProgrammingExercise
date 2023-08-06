//
//  Invoice.swift
//  XeroProgrammingExercise
//
//  Created by Brett Best on 6/8/2023.
//  Copyright © 2023 Xero Limited. All rights reserved.
//

import Foundation
import Tagged
import TaggedMoney

struct Invoice: Identifiable, Hashable {
  typealias ID = Tagged<Self, UInt>

  enum Error: Swift.Error {
    case invoiceItemExistsAlready
    case invoiceItemNotFound
    case invoiceMergeConflict
  }

  let id: ID
  let date: Date
  private(set) var lineItems: [InvoiceLine]

  var total: Dollars<Decimal> {
    lineItems.reduce(0) { partialResult, invoiceLine in
      partialResult + invoiceLine.totalCost
    }
  }

  init(id: ID, date: Date = Date(), lineItems: [InvoiceLine] = []) {
    self.id = id
    self.date = date
    self.lineItems = lineItems
  }

  mutating func addInvoiceLine(_ invoiceLine: InvoiceLine) throws {
    guard !lineItems.contains(where: { $0.id == invoiceLine.id }) else {
      throw Error.invoiceItemExistsAlready
    }

    lineItems.append(invoiceLine)
  }

  mutating func removeInvoiceLine(withId id: InvoiceLine.ID) throws {
    guard lineItems.contains(where: { $0.id == id }) else {
      throw Error.invoiceItemNotFound
    }

    lineItems.removeAll(where: { $0.id == id })
  }

  mutating func mergeInvoices(sourceInvoice: Self) throws {
    let lineItemIds = Set(lineItems.map(\.id))
    let sourceInvoiceLineItemIds = Set(sourceInvoice.lineItems.map(\.id))

    guard lineItemIds.isDisjoint(with: sourceInvoiceLineItemIds) else {
      throw Error.invoiceMergeConflict
    }

    lineItems.append(contentsOf: sourceInvoice.lineItems)
  }

  mutating func orderLineItemsById() {
    lineItems.sort(by: { $0.id < $1.id })
  }

  func lineItems(maxLength: Int) -> some Collection<InvoiceLine> {
    lineItems.prefix(maxLength)
  }

  func clone() -> Self {
    self
  }

  mutating func removeItems(from sourceInvoice: Self) {
    let sourceInvoiceLineItemIds = Set(sourceInvoice.lineItems.map(\.id))
    lineItems.removeAll(where: { sourceInvoiceLineItemIds.contains($0.id) })
  }

  func formatted() -> String {
    StandardFormatStyle.standard.format(self)
  }
}

extension Invoice {
  struct StandardFormatStyle: FormatStyle {
    func format(_ value: Invoice) -> String {
      "Invoice Number: \(value.id), InvoiceDate: \(value.date.formatted(date: .numeric, time: .omitted)), LineItemCount: \(value.lineItems.count)"
    }
  }
}

extension FormatStyle where Self == Invoice.StandardFormatStyle {
  static var standard: Self {
    Self()
  }
}
