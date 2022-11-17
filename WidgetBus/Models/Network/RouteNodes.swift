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
    //WGS84위도 좌표
    let gpslati: Double
    //WGS84 경도 좌표
    let gpslong: Double
    // 정류소 ID
    let nodeid: String
    // 정류소 명
    let nodenm: String
    // 정류소 번호
    let nodeno: Int
    // 정류소 순번
    let nodeord: Int
    // 노선 ID
    let routeid: String
    // 상하행 구분 코드
    let updowncd: Int
}
