//
//  API.swift
//  CatPics
//
//  Created by Alba Venzal on 02/04/2022.
//

import Foundation
import Moya

enum API {
    case getBreeds
    case getImages(GetImageRequest)
}

extension API: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.thecatapi.com/v1/")!
    }

    var path: String {
        switch self {
        case .getBreeds:
            return "breeds"
        case .getImages:
            return "images/search"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getBreeds, .getImages:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getBreeds:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .getImages(let object):
            var params: [String: Any] = [:]
            params["limit"] = object.numberOfImages
            params["breed_id"] = object.breedId
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json", "x-api-key": "3589e960-57bd-4760-a86b-9505d1a0d5ec"]
    }

    static var provider = MoyaProvider<API>()

    static func request<T: Decodable>(api: API, completion: @escaping (T?, Error?) -> Void) {
        API.provider.request(api) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    // The server responded, but we only consider successful response codes
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    let object = try JSONDecoder().decode(T.self, from: filteredResponse.data)
                    completion(object, nil)
                } catch let error {
                    completion(nil, error)
                }
            case let .failure(error):
                // this means there was a network failure - either the request
                // wasn't sent (connectivity), or no response was received (server
                // timed out).  If the server responds with a 4xx or 5xx error, that
                // will be sent as a ".success"-ful response.
                completion(nil, error)
            }
        }
    }
}
