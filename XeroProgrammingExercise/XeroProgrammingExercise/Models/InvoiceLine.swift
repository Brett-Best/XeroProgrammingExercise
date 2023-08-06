//
//  InvoiceLine.swift
//  XeroProgrammingExercise
//
//  Created by Brett Best on 6/8/2023.
//  Copyright © 2023 Xero Limited. All rights reserved.
//

import Foundation
import Tagged
import TaggedMoney

struct InvoiceLine: Identifiable, Hashable {
  typealias ID = Tagged<Self, UInt>

  let id: ID
  let description: String
  let quantity: UInt
  let cost: Dollars<Decimal>
}

extension InvoiceLine {
  var totalCost: Dollars<Decimal> {
    Dollars(cost.rawValue * Decimal(quantity))
  }
}
