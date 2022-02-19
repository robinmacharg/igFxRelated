//
//  API.swift
//  igFxRelated
//
//  Created by Robin Macharg on 18/02/2022.
//

import Foundation

public final class API {

    // Singleton
    public static let shared = API()
    
    let defaultSession = URLSession(configuration: .default)

    var dataTask: URLSessionDataTask?
    
    struct endpoints {
        static let markets = "https://content.dailyfx.com/api/v1/markets"
        static let articles = "https://content.dailyfx.com/api/v1/dashboard"
    }

    // Private to support the singleton pattern
    private init(session: URLSession = URLSession()) {}

    // MARK: - Markets API
    
    // TODO: There's obvious redundancy in the next two methods.  These should be parameterised and/or genericised.
    // The Markets & Articles types can provide their own endpoints.  We just need to pass their type.
    static func getMarkets(_ callback: ((Result<Markets, IGFxError>) -> Void)?) {
        if let url = URL(string: API.endpoints.markets) {
            let task = URLSession.shared.marketsTask(with: url) { markets, response, error in
                if error != nil {
                    callback?(.failure(IGFxError.networkError("\(error?.localizedDescription ?? "No description provided")")))
                }
                else {
                    if let markets = markets {
                        callback?(.success(markets))
                    }
                    else {
                        callback?(.failure(IGFxError.networkError(nil)))
                    }
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Articles API
    
    static func getArticles(_ callback: ((Result<Articles, IGFxError>) -> Void)?) {
        if let url = URL(string: API.endpoints.articles) {
            let task = URLSession.shared.articlesTask(with: url) { articles, response, error in
                if error != nil {
                    callback?(.failure(IGFxError.networkError("\(error?.localizedDescription ?? "No description provided")")))
                }
                else {
                    if let articles = articles {
                        callback?(.success(articles))
                    }
                    else {
                        callback?(.failure(IGFxError.dataError()))
                    }
                }
            }
            task.resume()
        }
    }
}

//    /**
//     * Construct a URLRequest object
//     */
//    static func makeURLRequest(squads: [SuperheroSquad]) -> Result<URLRequest, SuperHeroError> {
//        let json = Data.squadsAsJSON(squads: squads)
//        switch json {
//        case .success(let jsonString):
//            guard let url = URL(string: API.constants.endPoint) else {
//                return .failure(.generalError(SuperHeroError.errorTexts.urlError))
//            }
//
//            var urlRequest = URLRequest(url: url)
//            urlRequest.httpMethod = "GET"
////            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
////            urlRequest.httpBody = jsonString.data(using: .utf8)
//            urlRequest.setValue("\(String(describing: jsonString.data(using: .utf8)?.count))", forHTTPHeaderField: "Content-Length")
//
//            return .success(urlRequest)
//
//        case .failure(let error):
//            switch error {
//            case .failedToEncode:
//                return .failure(error)
//            default:
//                return .failure(SuperHeroError.generalError(SuperHeroError.errorTexts.generalError))
//            }
//        }
//    }
//
//    /**
//     * Send the request.  Uses a URLSession dataTask to ensure a background thread.
//     */
//    static func sendRequest(_ request: Request, callback: ((Any) -> ())?) {
//        let urlRequest = request.request
//
//        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//
//            // NOTE: artifical delay to help show async update of table
//            sleep(UInt32.random(in: 0...2))
//
//            // The next two guards are copy/paste boilerplate
//
//            // Check for fundamental networking error
//            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
//                print("error", error ?? "Unknown error")
//                return
//            }
//
//            // Check for HTTP errors
//            guard (200 ... 299) ~= response.statusCode else {
//                print("statusCode should be 2xx, but is \(response.statusCode)")
//                print("response = \(response)")
//                return
//            }
//
//            // Parse out data field
//            if let response = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
//               let json = response["data"] as? String,
//               let data = json.data(using: .utf8)
//            {
//                let decoder = JSONDecoder()
//                let superheroSquads = try? decoder.decode([SuperheroSquad].self, from: data)
//                request.returnedData = superheroSquads
//
//                callback?(request)
//            }
//
//            // Error
//            else {
//                fatalError("unhandled")
//            }
//        }
//
//        task.resume()
//    }
//}
