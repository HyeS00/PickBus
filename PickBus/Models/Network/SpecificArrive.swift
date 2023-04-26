//
//  SpecificArrive.swift
//  PickBus
//
//  Created by Jaehwa Noh on 2022/11/17.
//

import Foundation

struct SpecificArrive: Decodable {
    let response: SpecificArriveResponse
}

struct SpecificArriveResponse: Decodable {
    let header: SpecificArriveResponseHeader
    let body: SpecificArriveResponseBody
}

struct SpecificArriveResponseHeader: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct SpecificArriveResponseBody: Decodable {
    let items: SpeicificArriveResponseItems
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct SpeicificArriveResponseItems: Decodable {
    let item: MySpecificArriveInfoMultiType
}

struct SpecificArriveInfo: Decodable {
    /// 도착예정버스 남은 정류장 수
    let arrprevstationcnt: Int
    /// 도착예정버스 도착예상 시간
    let arrtime: Int
    /// 정류장 ID
    let nodeid: String
    /// 정류장 이름
    let nodenm: String
    /// 노선 ID
    let routeid: String
    /// 노선 번호
    let routeno: StringMultiType
    /// 노선 유형(마을 버스 등)
    let routetp: String
    /// 저상버스 여부
    let vehicletp: String?
}
