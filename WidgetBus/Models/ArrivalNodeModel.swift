//
//  ArrivalNodeModel.swift
//  WidgetBus
//
//  Created by LeeJaehoon on 2022/11/14.
//

import Foundation

struct ArrivalNodeModel {
//    let code: String?
    let name: String?
    var attribute: NodeAttribute?
    var userSelected: NodeSelected?
}

enum NodeAttribute {
    case first
    case nomal
    case turnaround
    case final
}

enum NodeSelected {
    case notSelected
    case depart(Departure.Toggle)
    case middle
    case arrival
}

enum Departure {
    enum Toggle {
        case onlyDep
        case notOnlyDep
    }
}
