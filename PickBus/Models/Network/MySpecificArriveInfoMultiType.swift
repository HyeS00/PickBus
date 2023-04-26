//
//  MySepcificArriveInfoMultiType.swift
//  PickBus
//
//  Created by Jaehwa Noh on 2022/12/09.
//

import Foundation

enum MySpecificArriveInfoMultiType: Decodable {
    case listItem([SpecificArriveInfo])
    case oneItem(SpecificArriveInfo)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let myValue = try? container.decode([SpecificArriveInfo].self) {
            self = .listItem(myValue)
            return
        }

        if let myValue = try? container.decode(SpecificArriveInfo.self) {
            self = .oneItem(myValue)
            return
        }

        throw DecodingError.typeMismatch(
            MySpecificArriveInfoMultiType.self,
            DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type"))
    }

    var listValue: [SpecificArriveInfo] {
        switch self {
        case .oneItem(let item):
            return [item]

        case .listItem(let items):
            return items
        }
    }
}
