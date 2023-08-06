//
//  InvoiceList.swift
//  XeroProgrammingExercise
//
//  Created by Brett Best on 6/8/2023.
//  Copyright © 2023 Xero Limited. All rights reserved.
//

import SwiftUI

struct InvoiceList: View {
  let invoiceResult: Result<[Invoice], Error>

  var body: some View {
    switch invoiceResult {
    case .success(let invoices):
      NavigationStack {
        List(invoices) { invoice in
          NavigationLink("\(invoice, format: .standard)", value: invoice)
        }
        .navigationDestination(for: Invoice.self, destination: InvoiceDetail.init)
        .navigationTitle("Invoices")
      }

    case .failure(let failure):
      Text(failure.localizedDescription)
    }
  }
}
