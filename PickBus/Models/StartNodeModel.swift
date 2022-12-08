//
//  StartNodeModel.swift
//  PickBus
//
//  Created by 김민재 on 2022/11/30.
//

import CoreLocation

struct StartNodeModel {
    let nodeName: String
    let nodeID: String
    let nodeNo: Int?
    let nodeCityCode: Int
    let nodeCityName: String
    let nodeCLLocationCoordinate2D: CLLocationCoordinate2D
}
