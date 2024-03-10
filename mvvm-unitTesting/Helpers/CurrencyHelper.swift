//
//  CurrencyHelper.swift
//  mvvm-unitTesting
//
//  Created by Aneesh on 09/03/24.
//

import Foundation


class CurrencyHelper {

    class func getMoneyString(_ value: Float) -> String{
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        return currencyFormatter.string(from: NSNumber(value: value)) ?? "0"
    }
}
