//
//  Event.swift
//  queuer
//
//  Created by Денис on 20/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation

struct Event {
    var name: String
    var date: Date
    var position: Int?
    var checkedIn = false

    init(name: String, date: Date) {
        self.name = name
        self.date = date
    }

    var readableDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy в HH:mm"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: date)
    }
    
    func checkIfExpired(){
        if date.isExpired {
            NotificationCenter.default.post(name: .invalidated, object: nil)
        }
    }
}
