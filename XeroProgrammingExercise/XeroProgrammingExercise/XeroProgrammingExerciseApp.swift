//
//  XeroProgrammingExerciseApp.swift
//  XeroProgrammingExercise
//
//  Created by Brett Best on 6/8/2023.
//  Copyright © 2023 Xero Limited. All rights reserved.
//

import SwiftUI

@main
enum XeroProgrammingExerciseApp {
  static func main() throws {
    guard nil == NSClassFromString("XCTestCase") else {
      TestApp.main()
      return
    }

    App.main()
  }
}

extension XeroProgrammingExerciseApp {
  struct App: SwiftUI.App {
    @State var invoiceResult: Result<[Invoice], Error>

    var body: some Scene {
      WindowGroup {
        InvoiceList(invoiceResult: invoiceResult)
      }
    }

    init() {
      let invoiceManager = InvoiceManager()
      invoiceManager.executeOperations()

      invoiceResult = Result(catching: { try invoiceManager.getInvoices() })
    }
  }
}

extension XeroProgrammingExerciseApp {
  struct TestApp: SwiftUI.App {
    var body: some Scene {
      WindowGroup {
        Text("Running unit tests…")
          .font(.largeTitle)
      }
    }
  }
}
