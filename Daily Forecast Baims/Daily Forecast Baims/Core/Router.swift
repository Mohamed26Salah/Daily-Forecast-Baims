//
//  Router.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 16/09/2024.
//

import Foundation
import Alamofire
import Combine
import Factory

public protocol RequestBuilder: URLRequestConvertible {
    var mainURL: String { get }
    var parameters: Parameters? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var url: URL { get }
    var urlRequest: URLRequest { get }
    var encoding: ParameterEncoding { get }
//    var APIVersion: String { get }
}

extension RequestBuilder {
    
    public var mainURL: String {
        return "https://api.openweathermap.org/data/2.5/"
    }
    
    public var headers: HTTPHeaders {
        var headers = URLSessionConfiguration.default.headers
//        let keychainService = Container.shared.keychainService()
//        if let accessToken = keychainService.loadToken(forKey: KeychainConfiguration.accessTokenKey) {
//            headers.add(name: "Authorization", value: "Bearer \(accessToken)")
//        }
//        if let lang = Localizator.shared.getLanguage()?.rawValue {
//            headers.add(name: "Accept-Language", value: lang)
//        }
//        return headers
       return headers
    }
    
    public var url: URL {
        var url = URL(string: mainURL)!
        url.appendPathComponent(path)
        return url
    }
    
    public var urlRequest: URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers.dictionary
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        return urlRequest
    }

    public var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.queryString
        case .post, .put, .patch:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    public func asUploadRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers.dictionary
        
        if method == .post || method == .put {
            urlRequest.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        }
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    @available(iOS 13.0, *)
    public func fetch<T: Decodable>() -> AnyPublisher<T, APIError> {
        printURL()

        return AF
            .request(self)
            .publishData()
            .tryMap { response in
                guard let httpResponse = response.response else {
                    throw APIError.apiError(message: "No response from server", statusCode: nil)
                }

                print("HTTP Status Code: \(httpResponse.statusCode)")

                // Check if the status code is 200 (OK)
                guard httpResponse.statusCode == 200 else {
                    throw APIError.apiError(message: "Invalid status code: \(httpResponse.statusCode)", statusCode: httpResponse.statusCode)
                }

                guard let data = response.data else {
                    throw APIError.apiError(message: "No data received", statusCode: httpResponse.statusCode)
                }

                printData(data)

                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    printDecodingErrors(decodingError)
                    return APIError.decoding
                } else if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.apiError(message: error.localizedDescription, statusCode: nil)
                }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    
    @available(iOS 13.0, *)
    public func uploadAndfetch<T: Codable>(uploadItems: [FileUploadItem]) -> AnyPublisher<T?, APIError> {
        printURL()
        
        return AF
            .upload(multipartFormData: { formData in
                if let parameters = parameters {
                    for (key, value) in parameters {
                        if let data = "\(value)".data(using: .utf8) {
                            formData.append(data, withName: key)
                        }
                    }
                }
                for (index, item) in uploadItems.enumerated() {
                    formData.append(item.data, withName: item.name, fileName: "image_\(index).jpg", mimeType: item.mimeType)
                }
            }, with: try! asUploadRequest())
            .publishData()
            .tryMap { response in
                guard let httpResponse = response.response else {
                    throw APIError.apiError(message: "No response from server", statusCode: nil)
                }
                
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                // Check if the status code is 200 (OK)
                guard httpResponse.statusCode == 200 else {
                    throw APIError.apiError(message: "Invalid status code: \(httpResponse.statusCode)", statusCode: httpResponse.statusCode)
                }
                
                guard let data = response.data else {
                    throw APIError.apiError(message: "No data received", statusCode: httpResponse.statusCode)
                }
                
                printData(data)
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder()) // Decode directly to non-optional T
            .map { decodedObject in
                return Optional(decodedObject) // Return optional T? to match return type
            }
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    printDecodingErrors(decodingError)
                    return APIError.decoding
                } else if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.apiError(message: error.localizedDescription, statusCode: nil)
                }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func printURL() {
#if DEBUG
        do {
            let urlStr = try "Getting \(asURLRequest().url!.absoluteURL)"
            print(urlStr)
        } catch {}
#endif
    }
    
    func printData(_ data: Data) {
#if DEBUG
        let urlStr = "Got \(url.absoluteURL)"
        print(urlStr)
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            let responseStr = String(decoding: jsonData, as: UTF8.self)
            print(responseStr)
        } else {
            print("Json data malformed")
        }
#endif
    }
    
    func printDecodingErrors(_ error: DecodingError) {
        print("DECODING ERROR!")
        var errorMessage = ""
        switch error {
        case .typeMismatch(let type, let context):
            errorMessage = "type mismatch for type \(type) in JSON: \(context.debugDescription)"
        case .valueNotFound(let type, let context):
            errorMessage = "could not find type \(type) in JSON: \(context.debugDescription)"
        case .keyNotFound(let key, let context):
            errorMessage = "could not find key \(key) in JSON: \(context.debugDescription)"
        case .dataCorrupted(let context):
            errorMessage = "data found to be corrupted in JSON: \(context.debugDescription)"
        default:
            errorMessage = "ERROR: \(error.localizedDescription)"
        }
        print(errorMessage)
    }
}


