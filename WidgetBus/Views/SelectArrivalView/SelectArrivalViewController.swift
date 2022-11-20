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

    var pageCount: Int = -1

    // var busNum: String?
    // 테스트용 
    var busNum: String = "207"

    // 0 정방향 or 1 역방향 / 회차지 구분용
    // 예) 0 > 0(회차지) > 1 > 1
    var upOrDown: Int?
    // 출발 정류장 인덱스
    var departNodeIdx: Int = 0

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "도착정류장을 선택해 주세요."
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()

    private let indicatorImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "progressIndicator4")
        return imageView
    }()

    private let busBadgeView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 91, height: 31)
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor.duduDeepBlue
        return view
    }()

    private lazy var busBadgeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = busNum
        return label
    }()

    private let busBadgeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bus.fill")
        imageView.tintColor = UIColor.white
        return imageView
    }()

    private let bottomView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = .white

        return view
    }()

    private let arrivalTableView: UITableView =  {
        let tableView = UITableView()
        tableView.register(ArrivalTableViewCell.self, forCellReuseIdentifier: ArrivalTableViewCell.identifier)
        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setBusNodeList()

        view.backgroundColor = UIColor.duduDeepBlue

        arrivalTableView.delegate = self
        arrivalTableView.dataSource = self
        arrivalTableView.separatorStyle = .none

        configureUI()

    }

    // MARK: - Helpers
    func configureUI() {
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.75).isActive = true
        bottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        bottomView.addSubview(busBadgeView)
        busBadgeView.translatesAutoresizingMaskIntoConstraints = false
        busBadgeView.widthAnchor
            .constraint(equalToConstant: busBadgeLabel.intrinsicContentSize.width + 42).isActive = true
        busBadgeView.heightAnchor.constraint(equalToConstant: busBadgeView.frame.height).isActive = true
        busBadgeView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 9).isActive = true
        busBadgeView.trailingAnchor
            .constraint(equalTo: bottomView.trailingAnchor, constant: -17).isActive = true

        busBadgeView.addSubview(busBadgeIcon)
        busBadgeIcon.translatesAutoresizingMaskIntoConstraints = false
        busBadgeIcon.widthAnchor
            .constraint(equalToConstant: 22).isActive = true
        busBadgeIcon.heightAnchor.constraint(equalToConstant: 19).isActive = true
        busBadgeIcon.centerYAnchor.constraint(equalTo: busBadgeView.centerYAnchor).isActive = true
        busBadgeIcon.leadingAnchor
            .constraint(equalTo: busBadgeView.leadingAnchor, constant: 7)
            .isActive = true

        busBadgeView.addSubview(busBadgeLabel)
        busBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        busBadgeLabel.centerYAnchor.constraint(equalTo: busBadgeView.centerYAnchor).isActive = true
        busBadgeLabel.leadingAnchor
            .constraint(equalTo: busBadgeIcon.trailingAnchor, constant: 5).isActive = true

        bottomView.addSubview(arrivalTableView)
        arrivalTableView.translatesAutoresizingMaskIntoConstraints = false
        arrivalTableView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        arrivalTableView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        arrivalTableView.topAnchor
            .constraint(equalTo: busBadgeView.bottomAnchor, constant: 10).isActive = true
        arrivalTableView.bottomAnchor.constraint(equalTo:bottomView.bottomAnchor).isActive = true

        view.addSubview(indicatorImage)
        indicatorImage.translatesAutoresizingMaskIntoConstraints = false
        indicatorImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorImage.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -10).isActive = true

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor
            .constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.1).isActive = true
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
            pageCount = iterater
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
            pageCount -= 1

        }

        if pageCount == 0 {
            nodeListJedi.sort {
                $0.nodeord < $1.nodeord
            }
            nodeInfoConversion(beforeNodes: nodeListJedi)
            let slice = nodeList[departNodeIdx...]
            nodeList = Array(slice)
            arrivalTableView.reloadData()
        }
    }

    // API 노선정보 변환 파싱, 출발정류장부터,
    func nodeInfoConversion(beforeNodes: [RouteNodesInfo]) {
        for (index, beforeNode) in beforeNodes.enumerated() {
            var nodeAttribute: NodeAttribute?
            var nodeSelected: NodeSelected?

            // 기점
            if beforeNode.nodeord == 1 {
                nodeAttribute = .first
            } else {
                nodeAttribute = .final
            }

            if upOrDown == nil {
                upOrDown = beforeNode.updowncd
            } else {
                if upOrDown != beforeNode.updowncd {
                    upOrDown = beforeNode.updowncd
                    nodeList[nodeList.endIndex - 1]?.attribute = .turnaround
                }
            }

            if !nodeList.isEmpty && nodeList.last!?.attribute == .final {
                nodeList[nodeList.endIndex - 1]?.attribute = .nomal
            }

            // 출발 정류장
            if beforeNode.nodeid == nodeId {
                nodeSelected = .depart(.onlyDep)
                departNodeIdx = index
            }

            nodeList.append(
                ArrivalNodeModel(
                    name: beforeNode.nodenm,
                    attribute: nodeAttribute,
                    userSelected: nodeSelected)
            )
        }
    }
}
// MARK: - UITableViewDelegate
extension SelectArrivalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - UITableViewDataSource
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
                //                print(index,"미들")
            } else if index == indexPath.row {
                nodeList[index]?.userSelected = .arrival
                //                print(index,"도착")
            } else {
                nodeList[index]?.userSelected = .notSelected
                //                print(index,"선택 X")
            }
        }
        arrivalTableView.reloadData()
    }
}
