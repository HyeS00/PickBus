//
//  RouteListData.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/13.
//

import Foundation

// Dummy-data
struct BusData {

    struct BusStop {
        var name: String
        var routes: [Route]

    }
    struct Route {
        var busNumber: String
        var busRemainingTime: String
        var nextBusRemainingTimeLabel: String
    }
}

extension BusData {
    static let busStops: [BusStop] = [
        BusStop(name: "포스텍", routes: [
            Route(busNumber: "207", busRemainingTime: "9분전", nextBusRemainingTimeLabel: "21분전"),
            Route(busNumber: "210", busRemainingTime: "전전", nextBusRemainingTimeLabel: "5분전"),
            Route(busNumber: "70", busRemainingTime: "곧도착", nextBusRemainingTimeLabel: "9분전"),
            Route(busNumber: "102", busRemainingTime: "7분전", nextBusRemainingTimeLabel: "27분전"),
            Route(busNumber: "105", busRemainingTime: "전", nextBusRemainingTimeLabel: "8분전")
        ]),
        BusStop(name: "신분당선강남역", routes: [
            Route(busNumber: "5007", busRemainingTime: "전전", nextBusRemainingTimeLabel: "6분전"),
            Route(busNumber: "5003", busRemainingTime: "곧도착", nextBusRemainingTimeLabel: "7분전"),
            Route(busNumber: "5006", busRemainingTime: "3분전", nextBusRemainingTimeLabel: "9분전"),
            Route(busNumber: "5107", busRemainingTime: "16분전", nextBusRemainingTimeLabel: "20분전")
        ]),
        BusStop(name: "잔다리마을이영미술관", routes: [
            Route(busNumber: "55", busRemainingTime: "7분전", nextBusRemainingTimeLabel: "22분전"),
            Route(busNumber: "28-2", busRemainingTime: "5분전", nextBusRemainingTimeLabel: "17분전"),
            Route(busNumber: "10-5", busRemainingTime: "4분전", nextBusRemainingTimeLabel: "9분전")
        ]),
        BusStop(name: "효자시장", routes: [
            Route(busNumber: "210", busRemainingTime: "9분전", nextBusRemainingTimeLabel: "13분전"),
            Route(busNumber: "207", busRemainingTime: "전전", nextBusRemainingTimeLabel: "13분전"),
            Route(busNumber: "210", busRemainingTime: "5분전", nextBusRemainingTimeLabel: "13분전")
        ])
    ]
}
