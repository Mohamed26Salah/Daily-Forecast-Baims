//
//  String + Extenstion.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 17/09/2024.
//

import Foundation

extension String {
    func toDisplayDateYYYYMMDD() -> String {
        return DateUtils.shared.formatDate(self, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "yyyy/MM/dd") ?? self
    }
}
