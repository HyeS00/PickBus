//
//  BusLocationInfoMultiType.swift
//  PickBus
//
//  Created by Jaehwa Noh on 2022/12/08.
//

import Foundation

enum BusLocationInfoMultiType: Decodable {
    case listItem([BusLocationsInfo])
    case oneItem(BusLocationsInfo)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let myValue = try? container.decode([BusLocationsInfo].self) {
            self = .listItem(myValue)
            return
        }

        if let myValue = try? container.decode(BusLocationsInfo.self) {
            self = .oneItem(myValue)
            return
        }

        throw DecodingError.typeMismatch(
            BusLocationsInfo.self,
            DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type"))
    }

    var listValue: [BusLocationsInfo] {
        switch self {
        case .oneItem(let item):
            return [item]

        case .listItem(let items):
            return items
        }
    }
}
