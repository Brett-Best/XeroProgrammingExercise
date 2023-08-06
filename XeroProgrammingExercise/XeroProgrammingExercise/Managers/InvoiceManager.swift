//
//  InvoiceManager.swift
//  XeroProgrammingExercise
//
//  Created by Brett Best on 6/8/2023.
//  Copyright © 2023 Xero Limited. All rights reserved.
//

class InvoiceManager {
  func executeOperations() {
    createInvoiceWithOneItem()
    createInvoiceWithMultipleItemsAndQuantities()
    removeItem()
    mergeInvoices()
    cloneInvoice()
    orderLineItems()
    previewLineItems()
    removeExtraItems()
    invoiceToString()
  }

  func createInvoiceWithOneItem() {
    var invoice = Invoice(id: 1)

    do {
      try invoice.addInvoiceLine(InvoiceLine(id: 1, description: "Pizza", quantity: 1, cost: 9.99))
    } catch {
      dump(error)
    }
  }

  func createInvoiceWithMultipleItemsAndQuantities() {
    var invoice = Invoice(id: 1)

    do {
      try invoice.addInvoiceLine(InvoiceLine(id: 1, description: "Banana", quantity: 4, cost: 10.21))
      try invoice.addInvoiceLine(InvoiceLine(id: 2, description: "Orange", quantity: 1, cost: 5.21))
      try invoice.addInvoiceLine(InvoiceLine(id: 3, description: "Pizza", quantity: 5, cost: 5.21))

      print(invoice.total)
    } catch {
      dump(error)
    }
  }

  func removeItem() {
    var invoice = Invoice(id: 1)

    do {
      try invoice.addInvoiceLine(InvoiceLine(id: 1, description: "Orange", quantity: 1, cost: 5.22))
      try invoice.addInvoiceLine(InvoiceLine(id: 2, description: "Banana", quantity: 4, cost: 10.33))
      try invoice.removeInvoiceLine(withId: 1)

      print(invoice.total)
    } catch {
      dump(error)
    }
  }

  func mergeInvoices() {
    var invoice1 = Invoice(id: 1)
    var invoice2 = Invoice(id: 2)

    do {
      try invoice1.addInvoiceLine(InvoiceLine(id: 1, description: "Banana", quantity: 4, cost: 10.33))
      try invoice2.addInvoiceLine(InvoiceLine(id: 2, description: "Orange", quantity: 1, cost: 5.22))
      try invoice2.addInvoiceLine(InvoiceLine(id: 3, description: "Blueberries", quantity: 3, cost: 6.27))
      try invoice1.mergeInvoices(sourceInvoice: invoice2)

      print(invoice1.total)
    } catch {
      dump(error)
    }
  }

  func cloneInvoice() {
    var invoice = Invoice(id: 1)

    do {
      try invoice.addInvoiceLine(InvoiceLine(id: 1, description: "Apple", quantity: 1, cost: 6.99))
      try invoice.addInvoiceLine(InvoiceLine(id: 2, description: "Blueberries", quantity: 3, cost: 6.27))

      let clonedInvoice = invoice.clone()
      print(clonedInvoice.total)
    } catch {
      dump(error)
    }
  }

  func invoiceToString() {
    var invoice = Invoice(id: 1)

    do {
      try invoice.addInvoiceLine(InvoiceLine(id: 1, description: "Apple", quantity: 1, cost: 6.99))
    } catch {
      print(invoice.formatted())
    }
  }

  func orderLineItems() {
    var invoice = Invoice(id: 1)

    do {
      try invoice.addInvoiceLine(InvoiceLine(id: 3, description: "Banana", quantity: 4, cost: 10.21))
      try invoice.addInvoiceLine(InvoiceLine(id: 2, description: "Orange", quantity: 1, cost: 5.21))
      try invoice.addInvoiceLine(InvoiceLine(id: 1, description: "Pizza", quantity: 5, cost: 5.21))

      invoice.orderLineItemsById()
      print(invoice.formatted())
    } catch {
      dump(error)
    }
  }

  func previewLineItems() {
    var invoice = Invoice(id: 1)

    do {
      try invoice.addInvoiceLine(InvoiceLine(id: 1, description: "Banana", quantity: 4, cost: 10.21))
      try invoice.addInvoiceLine(InvoiceLine(id: 2, description: "Orange", quantity: 1, cost: 5.21))
      try invoice.addInvoiceLine(InvoiceLine(id: 3, description: "Pizza", quantity: 5, cost: 5.21))

      let items = invoice.lineItems(maxLength: 1)
      print(items)
    } catch {
      dump(error)
    }
  }

  func removeExtraItems() {
    var invoice1 = Invoice(id: 1)
    var invoice2 = Invoice(id: 2)

    do {
      try invoice1.addInvoiceLine(InvoiceLine(id: 1, description: "Banana", quantity: 4, cost: 10.33))
      try invoice1.addInvoiceLine(InvoiceLine(id: 3, description: "Blueberries", quantity: 3, cost: 6.27))
      try invoice2.addInvoiceLine(InvoiceLine(id: 2, description: "Orange", quantity: 1, cost: 5.22))
      try invoice2.addInvoiceLine(InvoiceLine(id: 3, description: "Blueberries", quantity: 3, cost: 6.27))

      invoice2.removeItems(from: invoice1)
      print(invoice2.total)
    } catch {
      dump(error)
    }
  }

  func getInvoices() throws -> [Invoice] {
    var invoice1 = Invoice(id: 1)
    var invoice2 = Invoice(id: 2)
    var invoice3 = Invoice(id: 3)

    try invoice1.addInvoiceLine(InvoiceLine(id: 1, description: "Banana", quantity: 4, cost: 10.33))
    try invoice2.addInvoiceLine(InvoiceLine(id: 1, description: "Orange", quantity: 1, cost: 5.22))
    try invoice2.addInvoiceLine(InvoiceLine(id: 2, description: "Blueberries", quantity: 3, cost: 6.27))
    try invoice3.addInvoiceLine(InvoiceLine(id: 1, description: "Pizza", quantity: 1, cost: 9.99))

    return [invoice1, invoice2, invoice3]
  }
}
