//
//  RouteDetailViewController.swift
//  WidgetBus
//
//  Created by 김혜수 on 2022/11/12.
//

import UIKit
import CoreLocation

enum BoardingStatus {
    case onBoard
    case getOff
}

struct RouteModel {
    let startNodeId: String
    let endNodeId: String
}

struct CurrentBusLocationInfo {
    // 버스 위치
    var nodeord: Int
    // 버스 개수
    var cnt: Int
}

struct ClientBoardingStatus {
    var boardingState: BoardingStatus
    var vehicleno: String?
}

struct ClientLocation {
    var latitude: CLLocationDegrees?
    var longtitude: CLLocationDegrees?
}

class RouteDetailViewController: UIViewController {

    @IBOutlet weak var busNumberLabel: UILabel!
    @IBOutlet weak var startStationLabel: UILabel!
    @IBOutlet weak var endStationLabel: UILabel!
    @IBOutlet weak var busTimeInfoLabel: UILabel!

    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var routeView: UIView!
    @IBOutlet weak var routeDetailTableView: UITableView!

    @IBOutlet weak var boardingStateButton: UIButton!

    var boardingStatus: BoardingStatus = .onBoard

    let route: RouteModel = RouteModel(startNodeId: "DJB8001793", endNodeId: "DJB8007236")
    var startNodeIdIndex = 0
    var endNodeIdIndex = 0

    var clientBoardingStatus = ClientBoardingStatus(boardingState: .getOff, vehicleno : nil)
    var clientLocation = ClientLocation()

    let locationManager = CLLocationManager()

    // Jedi
    // 코어데이터에서 가져오는 정보들 (예정)
    // 노선 ID
    var routeId: String = "DJB30300004"
    // 정류장 ID
    var nodeId: String = "DJB8001793"
    // 도시 코드
    var cityCode: Int = 25
    // 버스 정류장들
    private var nodeList = [RouteNodesInfo]()
    // 버스 위치
    private var busLocationList = [BusLocationsInfo]()
    private var busLocationListIndex = 0
    private var busLocationIndexPath = [CurrentBusLocationInfo]()
    private var busLocationIndexPathIndex = 0
    // 특정 정류장에 도착예정 버스
    private var specificArriveInfo: SpecificArriveInfo?

    // 새로고침
    private func cofigureRefreshControl() {
        routeDetailTableView.refreshControl = UIRefreshControl()
        routeDetailTableView.refreshControl?
            .addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    @objc func handleRefreshControl() {
        busLocationListIndex = 0
        busLocationIndexPath = []
        busLocationList = []
        specificArriveInfo = nil

        DispatchQueue.main.async {
            self.callNetworkRefreshFunction()
            self.routeDetailTableView.refreshControl?.endRefreshing()
        }
    }

    @IBAction func tapBoardingStateButton(_ sender: UIButton) {
        switch self.boardingStatus {

        case .onBoard:
            if !busLocationList.isEmpty, clientLocation.latitude != nil, clientLocation.longtitude != nil {

                var nearestBus = CLLocationDistance(10000000)
                var nearestBusIndex = -1

                let clientLocation = CLLocationCoordinate2D(
                    latitude: clientLocation.latitude!,
                    longitude: clientLocation.longtitude!
                )

                for index in 0..<busLocationList.count {
                    let busLocation = CLLocationCoordinate2D(
                        latitude: busLocationList[index].gpslati,
                        longitude: busLocationList[index].gpslong
                    )
                    let distance = CLLocation.distance(
                        clientLocation: clientLocation,
                        busLocation: busLocation
                    )
                    if(nearestBus > distance) {
                        nearestBus = distance
                        nearestBusIndex = index
                    }
                    print("========차례로 버스거리\(distance)")
                }

                if(nearestBus < 1000000000000000) { // 특정 거리 설정을 어떻게 할까?
                    self.boardingStatus = .getOff
                    self.boardingStateButton.isSelected = true

                    clientBoardingStatus.boardingState = .onBoard
                    clientBoardingStatus.vehicleno = busLocationList[nearestBusIndex].vehicleno
                    routeDetailTableView.reloadData()
//                    print("====================버스 위치 \(clientBoardingStatus.vehicleno)")
//                    print("====================버스 거리 \(nearestBus)")
                }

            } else {
                if(!busLocationList.isEmpty) {

                } else if(clientLocation.latitude != nil && clientLocation.longtitude != nil) {

                } else {

                }
            }

        case .getOff:
            self.boardingStatus = .onBoard
            self.clientBoardingStatus.boardingState = .getOff
            self.clientBoardingStatus.vehicleno = nil
            self.boardingStateButton.isSelected = false
        }
    }

    let retryButton = UIButton(frame: CGRect(x: 318, y: 707, width: 55, height: 55))

    override func viewDidLoad() {
        super.viewDidLoad()
        // 네트워크 전송.
        callNetworkFunction()

        routeView.clipsToBounds = true
        routeView.layer.cornerRadius = 30
        routeView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)

        self.view.backgroundColor = .duduDeepBlue
        self.routeDetailTableView.dataSource = self
        self.routeDetailTableView.delegate = self
        busNumberLabel.text = "1000"

        refreshButton.layer.cornerRadius = 0.5 * retryButton.bounds.width
        refreshButton.setImage(#imageLiteral(resourceName: "retry"), for: .normal)
        refreshButton.backgroundColor = .duduDeepBlue
        refreshButton.addTarget(self, action: #selector(handleRefreshControl), for: .touchUpInside)
        self.configureBoardingTapButton()

        self.cofigureRefreshControl()

        // 여기 화면을 로드할떄 리퀘스트
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

    }
    // 네트워크 연결 부르는 함수
    func callNetworkFunction() {
        BusClient.getNodesListBody(
            city: String(cityCode),
            routeId: routeId,
            completion: handleRequestNodesTotalNumberResponse(response:error:))

        BusClient.getRouteInformation(
            city: String(cityCode),
            routeId: routeId,
            completion: handleRequestRouteInformation(response:error:))

        BusClient.getLocationsOnRoute(
            city: String(cityCode),
            routeId: routeId,
            completion: handleRequestLocationsOnRouteResponse(response:error:))

        BusClient.getSpecificArrive(
            city: String(cityCode),
            routeId: routeId,
            nodeId: nodeId,
            completion: handleRequestSpecificArriveInfoResponse(response:error:))
    }

    // 새로고침용 네트워크 연결 함수
    func callNetworkRefreshFunction() {
        BusClient.getLocationsOnRoute(
            city: String(cityCode),
            routeId: routeId,
            completion: handleRequestLocationsOnRouteResponse(response:error:))

        BusClient.getSpecificArrive(
            city: String(cityCode),
            routeId: routeId,
            nodeId: nodeId,
            completion: handleRequestSpecificArriveInfoResponse(response:error:))
    }

    func configureBoardingTapButton() {

        let boardText = "탑승"
        let boardAttribute = NSMutableAttributedString(string: boardText)
        let font = UIFont(name: "Helvetica-Bold", size: 40)
        boardAttribute.addAttribute(
            NSAttributedString.Key.font,
            value: font as Any,
            range: NSRange(location: 0, length: boardText.count)
        )
        self.boardingStateButton.setAttributedTitle(boardAttribute, for: .normal)

        let getOffText = "탑승취소"
        let getOffAttribute = NSMutableAttributedString(string: getOffText)
        getOffAttribute.addAttribute(
            NSAttributedString.Key.font,
            value: font as Any,
            range: NSRange(location: 0, length: getOffText.count)
        )
        self.boardingStateButton.setAttributedTitle(getOffAttribute, for: .selected)
    }

    // 전체 갯수 확인하는 네트워크 결과 받으면 실행되는 콜백.
    func handleRequestNodesTotalNumberResponse(response: RouteNodesResponseBody?, error: Error?) {
        if let response = response {
            let iterater: Int = (response.totalCount / response.numOfRows) + 1
            for index in 1...iterater {
                BusClient.getNodeList(
                    city: String(cityCode),
                    routeId: routeId,
                    pageNo: String(index),
                    completion: handleRequestNodesListResponse(response:error:))
            }
        }

        //        print("error")
        //        print(error?.localizedDescription ?? "")
    }

    // 버스 정류장 정보 받아오는 네트워크 결과 받으면 실행되는 콜백.
    func handleRequestNodesListResponse(response: [RouteNodesInfo], error: Error?) {
        guard !response.isEmpty else {
            //        print("error")
            //        print(error?.localizedDescription ?? "")
            return
        }

        nodeList += response

        nodeList.sort { $0.nodeord < $1.nodeord }

        startNodeIdIndex = nodeList.firstIndex { $0.nodeid == route.startNodeId }!
        endNodeIdIndex = nodeList.firstIndex { $0.nodeid == route.endNodeId }!

        print("Node List: \(nodeList.count)")
        routeDetailTableView.reloadData()
        scrollToRow()

    }

    // 노선 정보 받아오는 네트워크 결과 받으면 실행되는 콜백.
    func handleRequestRouteInformation(response: RouteInformationInfo?, error: Error?) {
        // 여기 버스 노선 정보 첫차, 막차 등.
        guard let response = response else {
            //        print("error")
            //        print(error?.localizedDescription ?? "")
            return
        }

        var startTime: String = response.startvehicletime
        var endTime: String = String(response.endvehicletime)
        var intervalTime: Int
        let today = Date()
        let weekday = Calendar.current.component(.weekday, from: today)

        switch weekday {
        case 1:// 일요일
            intervalTime = response.intervalsuntime
        case 7:// 토요일
            intervalTime = response.intervalsattime
        default:// 평일
            intervalTime = response.intervaltime
        }

        startTime.insert(":", at: startTime.index(startTime.startIndex, offsetBy: 2))
        endTime.insert(":", at: endTime.index(endTime.startIndex, offsetBy: 2))

        busTimeInfoLabel.text = "\(startTime) ~ \(endTime) 배차간격 \(intervalTime)분"
        //        print("RouteInformation: \(response)")
    }

    // 버스 위치 받아오는 네트워크 결과 받으면 실행되는 콜백.
    func handleRequestLocationsOnRouteResponse(response: [BusLocationsInfo], error: Error?) {
        // 여기 버스 위치들 나타남
        guard !response.isEmpty else {
            //        print("error")
            //        print(error?.localizedDescription ?? "")
            return
        }
        busLocationList += response
        busLocationList.sort { $0.nodeord < $1.nodeord }
        print("Locations: \(response)")
        routeDetailTableView.reloadData()
    }

    // 정류장에 오는 특정 노선에 대한 도착 정보만 받는 네트워크 결과 받으면 실행되는 콜백.
    func handleRequestSpecificArriveInfoResponse(response: SpecificArriveInfo?, error: Error?) {
        // 여기 특정 노선에 대한 도착 정보 표현 됨.
        guard let response = response else {
//                    print(error)
//                    print(error?.localizedDescription)
            return
        }
        print("Response: \(response)")
        specificArriveInfo = response
        routeDetailTableView.reloadData()
    }

    // 뷰가 로드된 후 상황에 맞게 scroll이동
    func scrollToRow() {
        var moveIndex: IndexPath

        switch clientBoardingStatus.boardingState {
        case .getOff:
            moveIndex = IndexPath(row: startNodeIdIndex, section: 0)
            self.routeDetailTableView.scrollToRow(at: moveIndex, at: .bottom, animated: true)
        case .onBoard:
            if let bus = busLocationList.first(where: {$0.vehicleno == clientBoardingStatus.vehicleno}) {
                moveIndex = IndexPath(row: bus.nodeord, section: 0)
                self.routeDetailTableView.scrollToRow(at: moveIndex, at: .bottom, animated: true)
            }
        }
    }
}

extension RouteDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "routeDetailCell",
            for: indexPath) as! RouteDetailTableViewCell
        let cellData = nodeList[indexPath.row]

        cell.busImageLabel2.layer.masksToBounds = true
        cell.busImageLabel2.layer.cornerRadius = 0.5 * 14

        // 출발지~목적지 색상 변경
        if (indexPath.row >= startNodeIdIndex && indexPath.row <= endNodeIdIndex) {
            cell.routePointImageView.tintColor = .duduDeepBlue
        } else {
            cell.routePointImageView.tintColor = .duduGray
        }
        if (indexPath.row >= startNodeIdIndex && indexPath.row <= endNodeIdIndex - 1) {
            cell.routeLineView.backgroundColor = .duduDeepBlue
        } else {
            cell.routeLineView.backgroundColor = .duduGray
        }

        cell.busView2.isHidden = true
        if nodeList.isEmpty {
            cell.busStationLabel.text = "불러오는 중입니다."
        } else {

            cell.busStationLabel.text = "\(cellData.nodenm)"

            cell.highlightView.layer.cornerRadius = 15

            // 출발지 도착지 표시
            if(route.startNodeId == cellData.nodeid) {
                cell.highlightView.isHidden = false
                cell.highlightView.backgroundColor = .duduRed
                cell.highlightLabel.text = "출발"
            } else if(route.endNodeId == cellData.nodeid) {
                self.view.sendSubviewToBack(self.view)
                cell.highlightView.isHidden = false
                cell.highlightView.backgroundColor = .duduBlue
                cell.highlightLabel.text = "도착"
            } else {
                cell.highlightView.isHidden = true
            }

            // 버스 위치
            if(busLocationList.isEmpty) {
                print("busLocationList 불러오는 중")
            } else {

                // 버스 위치 저장하기
                if(busLocationListIndex < busLocationList.count
                   && busLocationList[busLocationListIndex].nodeord == cellData.nodeord
                   && nodeList.endIndex != busLocationList[busLocationListIndex].nodeord) {

                    if(busLocationListIndex != 0
                       && busLocationList[busLocationListIndex - 1].nodeord
                       == busLocationList[busLocationListIndex].nodeord) {

                        busLocationIndexPath[busLocationIndexPathIndex].cnt += 1
                    } else {
                        busLocationIndexPath.append(CurrentBusLocationInfo(nodeord: indexPath.row, cnt: 1))
                        busLocationIndexPathIndex += 1
                    }
                    busLocationListIndex += 1
                }

                if let bus = busLocationIndexPath.first(where: {$0.nodeord == indexPath.row}) {
                    cell.busView2.isHidden = false
                    if(bus.cnt == 1) {
                        cell.busImageLabel2.isHidden = true
                    } else {
                        cell.busImageLabel2.isHidden = false
                        cell.busImageLabel2.text = String(bus.cnt)
                    }
                } else {
                    cell.busView2.isHidden = true
                }

                // 특정 버스 시간
                if let specificBusInfo = specificArriveInfo {
                    let specificBusLocation = startNodeIdIndex - specificBusInfo.arrprevstationcnt
                    if(specificBusLocation > 0) {
                        if(indexPath.row == specificBusLocation) {
                            cell.busTimeLabel2.isHidden = false
                            cell.busTimeLabel2.text = "\(specificBusInfo.arrtime / 60)분"
                        } else {
                            cell.busTimeLabel2.isHidden = true
                        }
                    }
                } else {
                    cell.busTimeLabel2.isHidden = true
                    print("현재 다가오는 버스가 없어요.")
                }
            }

            // 회차지 표시
            if(indexPath.row + 1 < nodeList.count
               && cellData.updowncd != nodeList[indexPath.row + 1].updowncd) {
                cell.routePointImageView.image = UIImage(systemName: "eraser")
            } else {
                cell.routePointImageView.image = UIImage(systemName: "chevron.down.circle")
            }

        }
        cell.busTimeLabel.layer.masksToBounds = true
        cell.busTimeLabel.layer.cornerRadius = 6.5
        cell.busView.isHidden = true
        cell.busTimeLabel2.layer.masksToBounds = true
        cell.busTimeLabel2.layer.cornerRadius = 6.5

        // 종점 표시
        let endNode = nodeList.count - 1
        if indexPath.row == endNode {
            cell.routeLineView.isHidden = true
        } else {
            cell.routeLineView.isHidden = false
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension RouteDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
}
