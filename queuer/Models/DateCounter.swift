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

    init(date: Date) {
        self.date = date
    }

    func update() {
        let calendar = Calendar.current
        let currentDate = Date(timeIntervalSinceNow: 0)
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: date)
        daysToNow = components
        observer?.didUpdate()
        checkIfExpired()
    }

    private func checkIfExpired() {
        if date.isExpired {
            NotificationCenter.default.post(name: .invalidated, object: nil)
        }
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

    private var secondText: String {
        return "\(daysToNow!.second!)"
    }

    var text: String {
        if daysToNow!.day == 0 {
            if daysToNow!.hour == 0 {
                if daysToNow!.minute == 0 {
                    return secondText
                }
                return minuteText
            }
            return hourText
        }
        return dayText
    }
}
