//
//  DateCounter.swift
//  queuer
//
//  Created by Денис on 21/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation

class DateCounter {
    var date: Date
    var observer: DateObserver?
    
    init(date: Date){
        self.date = date
    }
    
    func update() {
        let calendar = Calendar.current
        let currentDate = Date(timeIntervalSinceNow: 0)
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: date)
        daysToNow = components
        observer?.didUpdate()
    }
    
    var daysToNow: DateComponents?
    
    private var hourText: String {
        return "\(daysToNow!.hour!)ч"
    }
    
    private var minuteText: String {
        return "\(daysToNow!.minute!):\(daysToNow!.second!)"
    }
    
    private var dayText: String {
        return "\(daysToNow!.day!)д \(daysToNow!.hour!)ч"
    }
    
    var text: String {
        if daysToNow!.day == 0 {
            if daysToNow!.hour == 0 {
                return minuteText
            }
            return hourText
        }
        return dayText
    }
}
