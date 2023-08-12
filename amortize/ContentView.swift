//
//  ContentView.swift
//  amortize
//

import SwiftUI

struct LoanPayment:Identifiable {
  let paymentDate:Date
  let startingBalance:Decimal
  let totalPayment:Decimal
  let principalPayment:Decimal
  let interestPayment:Decimal
  let endingBalance:Decimal
  let id = UUID()
}

struct ContentView: View {
  
  @State private var principalAmount = ""
  @State private var interestRate = ""
  @State private var length = ""
  @State private var start:Date = Date.now
  @State private var schedule:[LoanPayment] = []
  
  var body: some View {
    VStack {
      TextField("Principal", text: $principalAmount)
      TextField("Interest Rate", text: $interestRate)
      TextField("Length", text: $length)
      DatePicker("Start Date", selection: $start
                 ,displayedComponents: [.date])
      Button("Calculate Payments") {
        print("Calculate")
        
        let p = Decimal(Int(principalAmount)!)
        let r = Decimal(Double(interestRate)!)
        let n = Int(self.length)
        let s = self.start
        
        let a = Amortizer(start: s, principal: p, length: n!, interestRate: r)
        
        schedule = a.schedule()
        
      }
    }
    .padding()
    
    Table(of:LoanPayment.self) {
      TableColumn("Date") { payment in
        Text(payment.paymentDate, format: .dateTime)}
      
      TableColumn("Starting Balance") { p in
        Text(p.startingBalance, format: .currency(code: "USD"))
      }
      
      TableColumn("Payment") { p in
        Text(p.totalPayment, format: .currency(code: "USD"))
      }
      
      TableColumn("Principal") { payment in
        Text(payment.principalPayment, format: .currency(code: "USD"))
      }
      
      TableColumn("Interest") { p in
        Text(p.interestPayment, format: .currency(code:"USD"))
      }
      
      TableColumn("Ending Balance") { p in
        Text(p.endingBalance, format: .currency(code: "USD"))
      }
      
    } rows: {
      ForEach(schedule) { p in
        TableRow(p)
      }
    }
    
    
    
    
  }
}

#Preview {
    ContentView()
}
