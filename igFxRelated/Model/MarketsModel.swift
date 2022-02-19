//
//  CurrencyModel.swift
//  igFxRelated
//
//  Created by Robin Macharg on 18/02/2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let markets = try? newJSONDecoder().decode(Markets.self, from: jsonData)

//
// To read values from URLs:
//
//   let task = URLSession.shared.marketsTask(with: url) { markets, response, error in
//     if let markets = markets {
//       ...
//     }
//   }
//   task.resume()

import Foundation

/**
 * Assumption: There are only three explicitly defined Markets
 */
enum MarketSection: Int {
    case currencies = 0
    case commodities
    case indices
    
    /**
     * Map a market to it's display name
     */
    var displayValue: String {
        switch self {
        case .commodities: return "Commodities"
        case .currencies: return "Currencies"
        case .indices: return "Indices"
        }
    }
}

// MARK: - Markets
struct Markets: Codable {
    let currencies, commodities, indices: [Market]
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.commodityTask(with: url) { commodity, response, error in
//     if let commodity = commodity {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Market
struct Market: Codable {
    let displayName, marketID, epic: String
    let rateDetailURL: String
    let topMarket: Bool
    let unscalingFactor, unscaledDecimals: Int
    let calendarMapping: [CalendarMapping]

    enum CodingKeys: String, CodingKey {
        case displayName
        case marketID = "marketId"
        case epic, rateDetailURL, topMarket, unscalingFactor, unscaledDecimals, calendarMapping
    }
}

enum CalendarMapping: String, Codable {
    case aud = "AUD"
    case cad = "CAD"
    case chf = "CHF"
    case cny = "CNY"
    case eur = "EUR"
    case gbp = "GBP"
    case jpy = "JPY"
    case mxn = "MXN"
    case nzd = "NZD"
    case usd = "USD"
}

// MARK: - URLSession response handlers

extension URLSession {
    func marketsTask(
        with url: URL,
        completionHandler: @escaping (Markets?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    {
        return self.codableTask(
            with: url,
            completionHandler: completionHandler)
    }
}
