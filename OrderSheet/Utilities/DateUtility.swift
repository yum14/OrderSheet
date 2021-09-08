//
//  DateUtility.swift
//  OrderSheet
//
//  Created by yum on 2021/09/08.
//

import Foundation

class DateUtility {
    static func toString(date: Date, template: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: Locale(identifier: "ja_JP"))
        
        return formatter.string(from: date)
    }
    
    static func toDate(dateString: String, template: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: Locale(identifier: "ja_JP"))
        return formatter.date(from: dateString)!
    }
}
