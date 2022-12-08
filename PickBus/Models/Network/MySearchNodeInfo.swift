//
//  MySearchNodeInfo.swift
//  PickBus
//
//  Created by Jaehwa Noh on 2022/11/20.
//

import Foundation

enum MySearchNodeInfo: Decodable {
    case listItem([SearchNodeInfo])
    case oneItem(SearchNodeInfo)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let myValue = try? container.decode([SearchNodeInfo].self) {
            self = .listItem(myValue)
            return
        }

        if let myValue = try? container.decode(SearchNodeInfo.self) {
            self = .oneItem(myValue)
            return
        }

        throw DecodingError.typeMismatch(
            MySearchNodeInfo.self,
            DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type"))
    }

    var listValue: [SearchNodeInfo] {
        switch self {
        case .oneItem(let item):
            return [item]

        case .listItem(let items):
            return items
        }
    }
}
