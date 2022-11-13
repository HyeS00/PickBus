//
//  ArriveInfoFromBusStop.swift
//  WidgetBus
//
//  Created by Jaehwa Noh on 2022/11/10.
//

import Foundation

struct ArriveInfoFromBusStop: Codable {
    let response: ArriveInfoResponseAPI
}

struct ArriveInfoResponseAPI: Codable {
    let header: ArriveInfoResponseHeader
    let body: ArriveInfoResponseBody
}

struct ArriveInfoResponseHeader: Codable {
    let resultCode: String
    let resultMsg: String
}

struct ArriveInfoResponseBody: Codable {
    let items: ArriveInfoResponseArriveItem
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct ArriveInfoResponseArriveItem: Codable {
    let item: [ArriveInfoResponseArriveInfo]
}

struct ArriveInfoResponseArriveInfo: Codable {
    let arrprevstationcnt: Int
    let arrtime: Int
    let nodeid: String
    let nodenm: String
    let routeid: String
    let routeno: Int
    let routetp: String
    let vehicletp: String
}
