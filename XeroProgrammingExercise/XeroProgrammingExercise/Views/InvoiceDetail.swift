//
//  InvoiceDetail.swift
//  XeroProgrammingExercise
//
//  Created by Brett Best on 6/8/2023.
//  Copyright © 2023 Xero Limited. All rights reserved.
//

import SwiftUI

struct InvoiceDetail: View {
  let invoice: Invoice

  var body: some View {
    List {
      ForEach(invoice.lineItems) { lineItem in
        Section(lineItem.description) {
          LabeledContent("Quantity", value: "\(lineItem.quantity)")
          LabeledContent("Cost per item", value: lineItem.cost.rawValue, format: .currency(code: "AUD"))
        }
      }

      Section("Total") {
        Text("\(invoice.total.rawValue, format: .currency(code: "AUD"))")
      }
    }
    .navigationTitle("\(invoice.date, format: .dateTime.day().month().year())")
  }
}
