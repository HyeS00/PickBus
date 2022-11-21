//
//  RouteListData.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/13.
//

import Foundation

// Dummy-data
struct BusData {

    struct Group {
        var id: Int // 원래는 UUID
        var name: String
        var nodes: [Node]
    }

    struct Node {
        var cityCode: String
        var nodeId: String
        var nodeNm: String
//        var nodeNo: String
        var buses: [Route]
    }
    struct Route {
        var routeID: String
        var routeNo: String
    }
}

extension BusData {

    static let groups: [Group] = [
        Group(id: 0, name: "출근", nodes: [
            Node(cityCode: "25", nodeId: "DJB8001793", nodeNm: "송강전통시장", buses: [
                Route(routeID: "DJB30300054", routeNo: "301"),
                Route(routeID: "DJB30300004", routeNo: "5")
            ]),
            Node(cityCode: "25", nodeId: "DJB8005972", nodeNm: "테크노밸리7단지", buses: [
                Route(routeID: "DJB30300054", routeNo: "301")
            ])
        ])
    ]

//    static let groups: [Group] = [
//        Group(gropName: "출근", busStops: [
//            BusStop(busStopName: "송강전통시장", busStopID: "DJB8001793",  routes: [
//                Route(busNumber: 5, id: , nextBusRemainingTimeLabel: "21분"),
//                Route(busNumber: 301, busRemainingTime: "전전", nextBusRemainingTimeLabel: "5분")
//            ]),
//            BusStop(busStopName: "잔다리마을.이영미술관", busStopID: "00000000", routes: [
//                Route(busNumber: "5007", busRemainingTime: "전전", nextBusRemainingTimeLabel: "6분"),
//                Route(busNumber: "5003", busRemainingTime: "곧도착", nextBusRemainingTimeLabel: "7분"),
//                Route(busNumber: "5006", busRemainingTime: "3분", nextBusRemainingTimeLabel: "9분"),
//                Route(busNumber: "5107", busRemainingTime: "16분", nextBusRemainingTimeLabel: "20분")
//            ])
//        ]),
//        Group(gropName: "퇴근", busStops: [
//            BusStop(busStopName: "신분당선강남역", busStopID: "00000000", routes: [
//                Route(busNumber: "5006", busRemainingTime: "7분", nextBusRemainingTimeLabel: "22분"),
//                Route(busNumber: "5100", busRemainingTime: "5분", nextBusRemainingTimeLabel: "17분"),
//                Route(busNumber: "5003", busRemainingTime: "4분", nextBusRemainingTimeLabel: "9분")
//            ]),
//            BusStop(busStopName: "우성아파트", busStopID: "00000000", routes: [
//                Route(busNumber: "5006", busRemainingTime: "9분", nextBusRemainingTimeLabel: "13분"),
//                Route(busNumber: "5100", busRemainingTime: "전전", nextBusRemainingTimeLabel: "13분"),
//                Route(busNumber: "5003", busRemainingTime: "5분", nextBusRemainingTimeLabel: "13분")
//            ])
//        ])
//
//    ]

//    static let busStops: [BusStop] = [
//        BusStop(name: "포스텍", routes: [
//            Route(busNumber: "207", busRemainingTime: "9분", nextBusRemainingTimeLabel: "21분"),
//            Route(busNumber: "210", busRemainingTime: "전전", nextBusRemainingTimeLabel: "5분"),
//            Route(busNumber: "70", busRemainingTime: "곧도착", nextBusRemainingTimeLabel: "9분"),
//            Route(busNumber: "102", busRemainingTime: "7분", nextBusRemainingTimeLabel: "27분"),
//            Route(busNumber: "105", busRemainingTime: "전", nextBusRemainingTimeLabel: "8분")
//        ]),
//        BusStop(name: "신분당선강남역", routes: [
//            Route(busNumber: "5007", busRemainingTime: "전전", nextBusRemainingTimeLabel: "6분"),
//            Route(busNumber: "5003", busRemainingTime: "곧도착", nextBusRemainingTimeLabel: "7분"),
//            Route(busNumber: "5006", busRemainingTime: "3분", nextBusRemainingTimeLabel: "9분"),
//            Route(busNumber: "5107", busRemainingTime: "16분", nextBusRemainingTimeLabel: "20분")
//        ]),
//        BusStop(name: "잔다리마을이영미술관", routes: [
//            Route(busNumber: "55", busRemainingTime: "7분", nextBusRemainingTimeLabel: "22분"),
//            Route(busNumber: "28-2", busRemainingTime: "5분", nextBusRemainingTimeLabel: "17분"),
//            Route(busNumber: "10-5", busRemainingTime: "4분", nextBusRemainingTimeLabel: "9분")
//        ]),
//        BusStop(name: "효자시장", routes: [
//            Route(busNumber: "210", busRemainingTime: "9분", nextBusRemainingTimeLabel: "13분"),
//            Route(busNumber: "207", busRemainingTime: "전전", nextBusRemainingTimeLabel: "13분"),
//            Route(busNumber: "210", busRemainingTime: "5분", nextBusRemainingTimeLabel: "13분")
//        ])
//    ]
}
