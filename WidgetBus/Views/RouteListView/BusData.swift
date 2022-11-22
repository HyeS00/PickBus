//
//  RouteListData.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/13.
//

import Foundation

// Dummy-data

struct Node {
    var cityCode: String
    var nodeId: String
    var nodeNm: String
}

struct Route {
    var routeNo: String
    var routeArr: Int?
    var routeNaextArr: Int?
    var routearrprevstationcnt: Int?
}
