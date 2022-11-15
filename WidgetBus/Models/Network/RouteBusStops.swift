//
//  RouteBusStops.swift
//  WidgetBus
//
//  Created by Jaehwa Noh on 2022/11/15.
//

import Foundation

struct RouteBusStops: Codable {
    let response: RouteBusStopsResponseAPI
}

struct RouteBusStopsResponseAPI: Codable {
    let header: RouteBusStopsResponseHeader
    let body: RouteBusStopsResponseBody
}

struct RouteBusStopsResponseHeader: Codable {
    let resultCode: String
    let resultMsg: String
}

struct RouteBusStopsResponseBody: Codable {
    let items: RouteBusStopsResponseItem
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct RouteBusStopsResponseItem: Codable {
    let item: [RouteBusStopsInfo]
}

struct RouteBusStopsInfo: Codable {
    let gpslati: Double
    let gpslong: Double
    let nodeid: String
    let nodenm: String
    let nodeno: Int
    let nodeord: Int
    let routeid: String
    let updowncd: Int
}
