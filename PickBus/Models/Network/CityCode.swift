//
//  CityCode.swift
//  PickBus
//
//  Created by Jaehwa Noh on 2022/11/20.
//

import Foundation

struct CityCode: Decodable {
    let response: CityCodeResponseAPI
}

struct CityCodeResponseAPI: Decodable {
    let header: CityCodeResponseHeader
    let body: CityCodeResponseBody
}

struct CityCodeResponseHeader: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct CityCodeResponseBody: Decodable {
    let items: CityCodeResponseItem
}

struct CityCodeResponseItem: Decodable {
    let item: [CityCodeInfo]
}

struct CityCodeInfo: Decodable {
    /// 도시 코드 (숫자)
    let citycode: Int
    /// 도시 이름 (글자)
    let cityname: String
}
