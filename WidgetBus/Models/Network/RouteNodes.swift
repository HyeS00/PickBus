//
//  RouteBusStops.swift
//  WidgetBus
//
//  Created by Jaehwa Noh on 2022/11/15.
//

import Foundation

struct RouteNodes: Codable {
    let response: RouteNodesResponseAPI
}

struct RouteNodesResponseAPI: Codable {
    let header: RouteNodesResponseHeader
    let body: RouteNodesResponseBody
}

struct RouteNodesResponseHeader: Codable {
    let resultCode: String
    let resultMsg: String
}

struct RouteNodesResponseBody: Codable {
    let items: RouteNodesResponseItem
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct RouteNodesResponseItem: Codable {
    let item: [RouteNodesInfo]
}

struct RouteNodesInfo: Codable {
    let gpslati: Double 
    let gpslong: Double
    let nodeid: String
    let nodenm: String
    let nodeno: Int
    let nodeord: Int
    let routeid: String
    let updowncd: Int
}
