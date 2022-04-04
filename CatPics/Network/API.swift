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

    /// The mocked data to be used, depending on the current route being called.
    var sampleData: Data {
        switch self {
        case .getBreeds:
            let filePath = Bundle.main.path(forResource: "breeds", ofType: "json")!
            return FileManager.default.contents(atPath: filePath)!
        case .getImages:
            let filePath = Bundle.main.path(forResource: "images", ofType: "json")!
            return FileManager.default.contents(atPath: filePath)!
        }
    }

    static var provider = MoyaProvider<API>(stubClosure: stubClosure, plugins: [CachePolicyPlugin()])

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

    /// The closure used to determine whether to stub or not, depending on the current configuration.
    static private let stubClosure: MoyaProvider<API>.StubClosure = {
        if CommandLine.arguments.contains("--uitesting") {
            return MoyaProvider.immediatelyStub
        } else {
            return MoyaProvider.neverStub
        }
    }()
}

// Add cache to network layer
final class CachePolicyPlugin: PluginType {
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var mutableRequest = request
        // Force use of cache if available
        mutableRequest.cachePolicy = .returnCacheDataElseLoad
        return mutableRequest
    }
}
