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
    let attribute: nodeAttribute?
    var userSelected: nodeSelected?
}

enum nodeAttribute {
    case first
    case nomal
    case turnaround
    case final
}

enum nodeSelected {
    case notSelected
    case departure
    case middle
    case arrival
}
