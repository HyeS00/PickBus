//
//  RouteNoMultiType.swift
//  WidgetBus
//
//  Created by Jaehwa Noh on 2022/11/26.
//

import Foundation

enum RouteNoMultiType: Decodable {
    case intItem(Int)
    case stringItem(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let myValue = try? container.decode(Int.self) {
            self = .intItem(myValue)
            return
        }

        if let myValue = try? container.decode(String.self) {
            self = .stringItem(myValue)
            return
        }

        throw DecodingError.typeMismatch(
            RouteNoMultiType.self,
            DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Mismatched Type"))
    }

    var stringValue: String {
        switch self {
        case .stringItem(let stringItem):
            return stringItem

        case .intItem(let intItem):
            return String(intItem)
        }

    }
}
