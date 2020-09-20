//
//  ApiClient.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/19/20.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CoreLocation

typealias HTTPHeaders = [String: String]
typealias HTTPParameters = [String: Any]

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

enum APIError: LocalizedError {

    case invalidURL
    case invalidResponse
    case responseError(code: Int, message: String)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid Response"
        case .responseError(let code, let message): return "Response Error \(code): \(message)"
        }
    }

}

enum APIErrorContent: String {
    case usernameAlreadyExists = "USERNAME_ALREADY_EXISTS"
    case phoneAlreadyExists = "PHONE_ALREADY_EXISTS"
    case notEnoughBalance = "NOT_ENOUGH_BALANCE"
    case notAValidBet = "NOT_A_VALID_BET"
    case externalIdWasAlreadyVerified = "EXT_ID_ALREADY_VERIFIED"
    case externalIdAlreadyExists = "EXT_ID_ALREADY_EXISTS"
    case usernameIsAvailable = "USERNAME_AVAILABLE"
    case allFieldsAreRequired = "ALL_FIELDS_ARE_REQUIRED"
    case invalidPwdLength = "INVALID_PASSWORD_LENGTH"
    case notFound = "NOT_FOUND"
    case invalidOldPwd = "INVALID_OLD_PASSWORD"
    case internalServerErr = "INTERNAL_SERVER_ERROR"
    case invalidUsernameOrPassword = "INVALID_USERNAME_OR_PASSWORD"
    case accountIsBlockedUntil = "ACCOUNT_IS_BLOCKED_UNTIL"
    case invalidPasswordStrength = "INVALID_PASSWORD_STRENGTH"
    
}

struct APIDefaults {

    static let defaultHeaders: HTTPHeaders =  [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]

    static let serviceURL = URL(string: Constants.Map.openWeatherBaseUrl.rawValue)

    private init() {}

}

class APIClient {

    static let shared = APIClient()

    private let baseURL: URL?

    private let session = URLSession(configuration: .default)

    init(baseURL: URL? = APIDefaults.serviceURL) {
        self.baseURL = baseURL
    }

    func void(_ resource: APIResource) -> Completable {
        return data(resource).asCompletable()
    }

    func decodable<T: Decodable>(_ resource: APIResource, printResponse: Bool = false) -> Single<T> {
        return data(resource).map({
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .millisecondsSince1970
                return try decoder.decode(T.self, from: $0.data)
            } catch let error {
                throw error
            }
        })
    }

    func data(_ resource: APIResource) -> PrimitiveSequence<SingleTrait, (response: HTTPURLResponse, data: Data)> {
        do {
            let request = try buildRequest(resource)
            return session.rx.response(request: request)
            .do(onNext: { response, _ in
                print(response)
            }, onError: { error in
                print(error)
            }).asSingle()
        } catch {
            print(error)
            return Single.error(error)
        }
    }

    private func buildRequest(_ resource: APIResource) throws -> URLRequest {
        let (method, path, headers, parameters) = resource.request

        guard let url = baseURL?.appendingPathComponent(path) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = APIDefaults.defaultHeaders.merging(headers) { (key, _) -> String in key }

        if method == .get, parameters.count > 0, let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            var components = components

            components.queryItems = parameters.map { (arg) -> URLQueryItem in
                let (key, value) = arg

                var strValue: String?

                if let value = value as? String {
                    strValue = value
                }

                if let number = value as? NSNumber {
                    strValue = number.stringValue
                }

                return URLQueryItem(name: key, value: strValue)
            }

            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

            request.url = components.url
        } else if method == .post || method == .put || method == .patch, JSONSerialization.isValidJSONObject(parameters) {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }

        let interval = TimeInterval()//ConfigManager.shared.requestCacheLife
        let refreshDate = Date.init(timeIntervalSinceNow: interval)
        session.configuration.urlCache?.removeCachedResponses(since: refreshDate)
        
        request.cachePolicy = resource.cachePolicy
        
        return request
    }

}
