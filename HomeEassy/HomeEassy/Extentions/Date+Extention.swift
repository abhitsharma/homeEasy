//
//  Date+Extention.swift
//  CLG
//
//  Created by Aravind Kumar on 10/09/21.
//

import Foundation
import UIKit

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    func dateFormatWithSuffix() -> String {
        return "dd'\(self.daySuffix())' MMMM, EEEE"
    }
    func dateFormatWithSuffixForInfo() -> String {
        return "EE, dd'\(self.daySuffix())' MMM, yyyy"
    }

    func daySuffix() -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
}

class DateFormatters: NSObject {
var cache = NSCache<NSString, DateFormatter>()
   static let sharedManager = DateFormatters()
        
    private override init() {
        super.init()
        self.cache = NSCache()
        self.cache.name = "Date Formatters"
        
    }
    
    func formatterForStrings(dateFormat: String) -> DateFormatter {
        var relativeDateFormatter: DateFormatter? = cache.object(forKey: "dateFormat" as NSString)
        if relativeDateFormatter != nil {
            relativeDateFormatter?.dateFormat = dateFormat
            return relativeDateFormatter!
        }
        relativeDateFormatter = DateFormatter()
        relativeDateFormatter?.dateFormat = dateFormat
        // NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        //  [formatter setTimeZone:timeZone];
        relativeDateFormatter?.timeZone = NSTimeZone.system
       cache.setObject(relativeDateFormatter!, forKey: "dateFormat" as NSString)
        return relativeDateFormatter!
    }
    func relativeDateFormt() -> DateFormatter {
        var relativeDateFormatter: DateFormatter? = cache.object(forKey: "rel" as NSString)
        if relativeDateFormatter != nil {
            return relativeDateFormatter!
        }
        relativeDateFormatter = DateFormatter()
       // formatter?.timeZone = NSTimeZone.system
        relativeDateFormatter?.timeStyle = .none
        relativeDateFormatter?.dateStyle = .medium
        relativeDateFormatter?.locale = Locale(identifier: "en_GB")
        relativeDateFormatter?.doesRelativeDateFormatting = true
       cache.setObject(relativeDateFormatter!, forKey: "rel" as NSString)
        return relativeDateFormatter!
    }
}

extension TimeInterval{
        func stringFromTimeInterval() -> String {
            let time = NSInteger(self)
            let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
            let seconds = time % 60
            let minutes = (time / 60) % 60
            let hours = (time / 3600)
            if hours>0{
                return String(format: "%0.2dH : %0.2dM : %0.2dS",hours,minutes,seconds,ms)
            }
            else{
                return String(format: "%0.2dM : %0.2dS",minutes,seconds,ms)
            }
           

        }
    }
