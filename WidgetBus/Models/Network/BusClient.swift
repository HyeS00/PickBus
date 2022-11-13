//
//  BusClient.swift
//  WidgetBus
//
//  Created by Jaehwa Noh on 2022/11/10.
//

import Foundation

class BusClient {
    //
    static var apiKey: String {
        get {
            guard let url = Bundle.main.url(forResource: "Service Key", withExtension: "plist") else {
                return ""
            }
            guard let dictionary = NSDictionary(contentsOf: url) else {
                return ""
            }
            //
            return dictionary["BusStop"] as? String ?? ""
            //
        }
    }
    //
    //
    enum Endpoints {
        static let base = "http://apis.data.go.kr"
        static let apiKeyParam = "?serviceKey=\(BusClient.apiKey)"
        //
        case getArriveList(city: String, busStopId: String)
        case getCityCodeList
        //
        var stringValue: String {
            switch self {
            case .getArriveList(let city, let busStopId):
                return Endpoints.base +
                "/1613000/ArvlInfoInqireService/getSttnAcctoArvlPrearngeInfoList" +
                Endpoints.apiKeyParam +
                "&_type=json&cityCode=\(city)&nodeId=\(busStopId)"
            case .getCityCodeList:
                return Endpoints.base +
                "/1613000/BusSttnInfoInqireService/getCtyCodeList" +
                Endpoints.apiKeyParam + "&_type=json"
            }
        }
        //
        var url: URL {
            return URL(string: stringValue)!
        }
        //
    }
    //
    //
    class func taskForGETRequest<ResponseType: Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        completion: @escaping (ResponseType?, Error?) -> Void
    ) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print("data is nil")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                print(String(decoding: data, as: UTF8.self))
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        //
        return task
    }
    //
    class func getArriveList(completion: @escaping ([ArriveInfoResponseArriveInfo], Error?) -> Void) {
        _ = taskForGETRequest(
            url: Endpoints.getArriveList(city: "25", busStopId: "DJB8001793").url,
            responseType: ArriveInfoFromBusStop.self) { response, error in
                if let response = response {
//                    print("good")
//                    print(response)
                    completion(response.response.body.items.item, nil)
                } else {
//                    print("response is nil")
                    completion([], error)
                }
            }
    }
    //
}
