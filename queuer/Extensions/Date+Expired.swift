//
//  Date+Expired.swift
//  queuer
//
//  Created by Денис on 21/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation

extension Date {
    var isExpired: Bool {
        return compare(Date(timeIntervalSinceNow: 0)) == .orderedAscending
    }
}
