//
//  Dateble.swift
//  FinalPython_iOS
//
//  Created by fsociety.1 on 11/23/18.
//  Copyright © 2018 fsociety.1. All rights reserved.
//

import UIKit

struct Data: Codable {
    let timetable: [Timetable]
}

struct Timetable: Codable {
    let id, subject_id, teacher_id, bundle_id, day_id, time_id, subject_type_id: String
    let time_value: TimeValue
}

struct TimeValue: Codable {
    let start_time, end_time: String
}

extension Date {
    
    func dateAt(hours: Int, minutes: Int) -> Date {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        //get the month/day/year componentsfor today's date.
        
        
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
}

protocol Dateble {
    func getSequencingByName(name: String) -> Int
    func getDayOfWeekByName(name: String) -> Int
    func getDayOfWeek() -> Int
    func checkTimeRange() -> Int
}

extension Dateble where Self: UIViewController {
    
    
    func getSequencingByName(name: String) -> Int {
        switch name {
        case "first":
            return 1
        case "second":
            return 2
        case "third":
            return 3
        case "fourth":
            return 4
        case "fifth":
            return 5
        case "sixth":
            return 6
        case "seventh":
            return 7
        case "eighth":
            return 8
        case "ninth":
            return 9
        case "tenth":
            return 10
        case "eleventh":
            return 11
        case "twelfth":
            return 12
        default:
            return 0
        }
    }
    
    func getDayOfWeekByName(name: String) -> Int {
        switch name {
        case "Monday":
            return 1
        case "Tuesday":
            return 2
        case "Wednesday":
            return 3
        case "Thursday":
            return 4
        case "Friday":
            return 5
        case "Saturday":
            return 6
        case "Sunday":
            return 7
        default:
            return 0
        }
    }
    
    func getDayOfWeek() -> Int {
        let date = Date()
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        let todayDate = formatter.date(from: result)
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate!) - 1
        return weekDay
    }
    
    func checkTimeRange() -> Int {
        let now = Date()
        
        let start1 = now.dateAt(hours: 8, minutes: 0)
        let finish1 = now.dateAt(hours: 8, minutes: 50)
        
        let start2 = now.dateAt(hours: 9, minutes: 0)
        let finish2 = now.dateAt(hours: 9, minutes: 50)
        
        let start3 = now.dateAt(hours: 10, minutes: 0)
        let finish3 = now.dateAt(hours: 10, minutes: 50)
        
        let start4 = now.dateAt(hours: 11, minutes: 0)
        let finish4 = now.dateAt(hours: 11, minutes: 50)
        
        let start5 = now.dateAt(hours: 12, minutes: 10)
        let finish5 = now.dateAt(hours: 13, minutes: 0)
        
        let start6 = now.dateAt(hours: 13, minutes: 10)
        let finish6 = now.dateAt(hours: 14, minutes: 0)
        
        let start7 = now.dateAt(hours: 14, minutes: 10)
        let finish7 = now.dateAt(hours: 15, minutes: 0)
        
        let start8 = now.dateAt(hours: 15, minutes: 10)
        let finish8 = now.dateAt(hours: 16, minutes: 0)
        
        let start9 = now.dateAt(hours: 16, minutes: 10)
        let finish9 = now.dateAt(hours: 17, minutes: 0)
        
        let start10 = now.dateAt(hours: 17, minutes: 20)
        let finish10 = now.dateAt(hours: 18, minutes: 10)
        
        let start11 = now.dateAt(hours: 18, minutes: 30)
        let finish11 = now.dateAt(hours: 19, minutes: 20)
        
        let start12 = now.dateAt(hours: 19, minutes: 30)
        let finish12 = now.dateAt(hours: 20, minutes: 20)
        
        if now >= start1 && now <= finish1 {
            return 1
        }
        else if now >= start2 && now <= finish2 {
            return 2
        }
        else if now >= start3 && now <= finish3 {
            return 3
        }
        else if now >= start4 && now <= finish4 {
            return 4
        }
        else if now >= start5 && now <= finish5 {
            return 5
        }
        else if now >= start6 && now <= finish6 {
            return 6
        }
        else if now >= start7 && now <= finish7 {
            return 7
        }
        else if now >= start8 && now <= finish8 {
            return 8
        }
        else if now >= start9 && now <= finish9 {
            return 9
        }
        else if now >= start10 && now <= finish10 {
            return 10
        }
        else if now >= start11 && now <= finish11 {
            return 11
        }
        else if now >= start12 && now <= finish12 {
            return 12
        }
        else {
            return -1
        }
    }
    
}
