//
//  SelectArrivalViewController.swift
//  WidgetBus
//
//  Created by LeeJaehoon on 2022/11/14.
//

import UIKit

class SelectArrivalViewController: UIViewController {

    // MARK: - Properties
    var nodeList: [ArrivalNodeModel?] = []

    // 변수 이름은 원하는 대로 변경하시면 됩니다.
    var nodeListJedi = [RouteNodesInfo]()

    // Jedi
    // 이전 뷰에서 넘어올 정보들
    // 노선 ID
    var routeId: String = "DJB30300004"
    // 정류장 ID
    var nodeId: String = "DJB8001793"
    // 도시 코드
    var cityCode: Int = 25

    private let arrivalTableView: UITableView =  {
        let tableView = UITableView()
        tableView.register(ArrivalTableViewCell.self, forCellReuseIdentifier: ArrivalTableViewCell.identifier)
        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        nodeList = setDummyBusNodeList()

        // 버스 노드 추가 함수.
        setBusNodeList()

        arrivalTableView.delegate = self
        arrivalTableView.dataSource = self
        arrivalTableView.separatorStyle = .none

        configureUI()

    }

    // MARK: - Helpers
    func configureUI() {
        view.addSubview(arrivalTableView)
        arrivalTableView.frame = view.bounds
    }

    func setBusNodeList() {
        BusClient.getNodesListBody(
            city: String(cityCode),
            routeId: routeId,
            completion: handleRequestNodesTotalNumberResponse(response:error:))
    }

    // 버스노선 더미 데이터
    func setDummyBusNodeList() -> [ArrivalNodeModel] {
        let nodeList: [ArrivalNodeModel] = [
            ArrivalNodeModel(name: "포스텍", attribute: .nomal, userSelected: .depart(.onlyDep)),
            ArrivalNodeModel(name: "생명공학연구소", attribute: .nomal, userSelected: .notSelected),
            ArrivalNodeModel(name: "효곡동행정복지센터", attribute: .nomal, userSelected: .notSelected),
            ArrivalNodeModel(name: "효자아트홀", attribute: .nomal, userSelected: .notSelected),
            ArrivalNodeModel(name: "포항성모병원", attribute: .nomal, userSelected: .notSelected),
            ArrivalNodeModel(name: "대잠사거리", attribute: .nomal, userSelected: .notSelected),
            ArrivalNodeModel(name: "시외버스터미널", attribute: .nomal, userSelected: .notSelected),
            ArrivalNodeModel(name: "교보생명", attribute: .nomal, userSelected: .notSelected),
            ArrivalNodeModel(name: "산업은행", attribute: .nomal, userSelected: .notSelected),
            ArrivalNodeModel(name: "고용복지플러스센터", attribute: .final, userSelected: .notSelected)
        ]

        return nodeList

    }

    // 전체 갯수 확인하는 네트워크 받으면 실행되는 콜백.
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

    // 버스 정류장 정보 받아오는 네트워크 받으면 실행되는 콜백.
    func handleRequestNodesListResponse(response: [RouteNodesInfo], error: Error?) {
        if !response.isEmpty {
            nodeListJedi += response
        }

        print("Jerry Node List: \(nodeListJedi.count)")

//        print("error")
//        print(error?.localizedDescription ?? "")
    }

}
extension SelectArrivalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension SelectArrivalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
                arrivalTableView.dequeueReusableCell(
                    withIdentifier: ArrivalTableViewCell.identifier,
                    for: indexPath
                ) as? ArrivalTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(nodeInfo: nodeList[indexPath.row]!)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in nodeList.indices {
            if index == 0 {
                if indexPath.row == 0 {
                    nodeList[0]?.userSelected = .depart(.onlyDep)
                } else {
                    nodeList[0]?.userSelected = .depart(.notOnlyDep)
                }

                continue
            }
            // 1번 인덱스 부터 마지막 전 인덱스 까지
            if index < indexPath.row {
                nodeList[index]?.userSelected = .middle
                print(index,"미들")
            } else if index == indexPath.row {
                nodeList[index]?.userSelected = .arrival
                print(index,"도착")
            } else {
                nodeList[index]?.userSelected = .notSelected
                print(index,"선택 X")
            }
        }
        arrivalTableView.reloadData()
    }
}
