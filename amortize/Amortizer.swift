//
//  Amortizer.swift
//  amortize
//

import Foundation

class Amortizer {
  
  var principal:Decimal = 0.0;
  var length:Int = 0;
  var interestRate:Decimal = 0.0;
  var start:Date = Date.now
  var payments:[LoanPayment] = [];
  
  init(start:Date, principal:Decimal, length:Int, interestRate:Decimal) {
    self.start = start;
    self.principal = principal;
    self.length = length;
    self.interestRate = interestRate;
  }
  
  func calculateSchedule() {
    
    let r = interestRate/12;
    let n = length;
    print(r)
    
    let monthlyPayment = principal /
        ((pow(1 + r, n) - 1) / (r * pow(1 + r,n)))
    
    print(monthlyPayment)
    
    var balance = principal;
    var nextPayment = self.start

    let calendar = Calendar.current;
    let dayOfMonth = calendar.dateComponents([.day], from: self.start).day
    
    for _ in 1...n {
      
      let interestPayment = r*balance
      let principalPayment = monthlyPayment-interestPayment
      
      let payment = LoanPayment(paymentDate: nextPayment,
                                startingBalance: balance,
                                totalPayment: monthlyPayment,
                                principalPayment: monthlyPayment-interestPayment,
                                interestPayment: interestPayment,
                                endingBalance: balance-principalPayment)
              
      payments.append(payment)
      
      balance = balance-principalPayment;
      nextPayment =  Calendar.current.nextDate(after: nextPayment,
                                               matching: DateComponents(day: dayOfMonth), matchingPolicy: .previousTimePreservingSmallerComponents)!

      
      
    }
    
  }
  
  func schedule() -> [LoanPayment]{
    self.calculateSchedule()
    return payments;
  }
  
}
