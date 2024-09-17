//
//  Icons.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 17/09/2024.
//

import Foundation


enum Icons: String {
    case downArrow = "ic_down_arrow"
    case checkMark = "ic_check_mark"
    case emptySquare = "ic_empty_square"

     public var name: String {
         return self.rawValue
     }
}
