//
//  DateUtilits.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 17/09/2024.
//

import Foundation

extension DateFormatter {
    public static func defaultFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone.current // Use current system time zone
        return dateFormatter
    }
}

public class DateUtils {
    
    // Singleton instance
    public static let shared = DateUtils()
    
    private let dateFormatter = DateFormatter.defaultFormatter()
    
    private init() { } // Prevents initialization from outside
    
    public func formatDate(dateFormat: String) -> String {
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: Date())
    }
    
    public func formatDate(_ date: Date, fullDateFormat: String) -> String {
        dateFormatter.dateFormat = fullDateFormat
        return dateFormatter.string(from: date)
    }
    
    public func formatDate(_ dateString: String, fromFormat: String, toFormat: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = fromFormat
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = toFormat
            return formatter.string(from: date)
        } else {
            return nil
        }
    }

    // Attempt to parse and format a date string with multiple formats
    public func formatDate(dateString: String, inputFormats: [String], outputFormat: String) -> String? {
        for format in inputFormats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateString) {
                dateFormatter.dateFormat = outputFormat
                return dateFormatter.string(from: date)
            }
        }
        print("Invalid date format for all provided formats")
        return nil
    }
    
    public func parseDate(dateString: String, inputFormats: [String]) -> Date? {
        for format in inputFormats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        }
        return nil
    }
}
