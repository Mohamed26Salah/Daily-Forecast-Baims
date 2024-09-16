//
//  APIError.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 16/09/2024.
//

import Foundation
public enum APIError: Error, LocalizedError , Equatable {
    
    case unknown, apiError(message: String?, statusCode: Int?), decoding

    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Server Error"
        case .apiError(let message, _ ):
            return message ?? "Server Error"
        case .decoding:
            return "Decoding Error"
        }
    }
}

public struct FileUploadItem {
    var data: Data
    var mimeType: String
    var name: String
    
    public init(data: Data, mimeType: String, name: String) {
        self.data = data
        self.mimeType = mimeType
        self.name = name
    }
}
