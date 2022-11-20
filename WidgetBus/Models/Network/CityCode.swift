//
//  CityCode.swift
//  WidgetBus
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
    let citycode: Int
    let cityname: String
}
