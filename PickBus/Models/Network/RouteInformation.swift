//
//  RouteInformation.swift
//  PickBus
//
//  Created by Jaehwa Noh on 2022/11/17.
//

import Foundation

struct RouteInformation: Decodable {
    let response: RouteInformationResponse
}

struct RouteInformationResponse: Decodable {
    let header: RouteInformationResponseHeader
    let body: RouteInformationResponseBody
}

struct RouteInformationResponseHeader: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct RouteInformationResponseBody: Decodable {
    let items: RouteInformationResponseItem
}

struct RouteInformationResponseItem: Decodable {
    let item: RouteInformationInfo
}

struct RouteInformationInfo: Decodable {
    /// 종점
    let endnodenm: String
    /// 막차 시간
    let endvehicletime: Int
    /// 배차 간격(토요일)
    let intervalsattime: Int
    /// 배차 간격(일요일)
    let intervalsuntime: Int
    /// 배차 간격(평일)
    let intervaltime: Int
    /// 노선 ID
    let routeid: String
    /// 노선 번호
    let routeno: Int
    /// 노선 유형(마을 버스 등)
    let routetp: String
    /// 기점
    let startnodenm: String
    /// 첫차 시간
    let startvehicletime: String
}
