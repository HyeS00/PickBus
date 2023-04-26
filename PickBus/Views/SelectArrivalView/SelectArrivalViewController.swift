//
//  SelectArrivalViewController.swift
//  PickBus
//
//  Created by LeeJaehoon on 2022/11/14.
//

import UIKit

final class SelectArrivalViewController: BackgroundViewController {

    // MARK: - Properties
    private var nodeList: [ArrivalNodeModel?] = []

    // 변수 이름은 원하는 대로 변경하시면 됩니다.
    private var nodeListJedi = [RouteNodesInfo]()

    var newBus: Bus!
    var dataController: DataController!
    var newNode: Node!
    var newGroup: Group!

    // Jedi
    // 이전 뷰에서 넘어올 정보들
    /// 노선 ID
    private var routeId: String = "DJB30300004"
    /// 정류장 ID
    private var nodeId: String = "DJB8001793"
    /// 도시 코드
    private var cityCode: String = "25"

    private var pageCount: Int = -1

    var busNum: String?

    // 0 정방향 or 1 역방향 / 회차지 구분용
    // 예) 0 > 0(회차지) > 1 > 1
    private var upOrDown: Int?
    // 출발 정류장 인덱스
    private var departNodeIdx: Int = 0
    // 도착정류장 선택 유뮤
    private var isArrivalOn: Bool = false

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private lazy var busBadgeView: BusBadgeView = {
        let view = BusBadgeView(frame: .zero, busNum: self.busNum ?? "버스번호미입력")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let arrivalTableView: UITableView =  {
        let tableView = UITableView()
        tableView.register(ArrivalTableViewCell.self, forCellReuseIdentifier: ArrivalTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor.duduGray, for: .normal)
        button.addTarget(self, action: #selector(doneButtonSelect), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

//        super.setTitleAndIndicator(
//            titleText: "도착 정류장을\n선택해 주세요",
//            indicatorStep: checkAddGroupViewInStack() ? .stepFour : .stepThreeOfThree
//        )

        super.setTitleAndIndicator(
            titleText: "도착 정류장을\n선택해 주세요",
            indicatorStep: .stepFour
        )

        setInformations()
        setBusNodeList()

        configureTableView()
        configureNavigationBar()
        configureUI()
        self.extendedLayoutIncludesOpaqueBars = true
    }

    // 네비게이션 스택에 AddGroupListNameViewController가 있는지 확인
    func checkAddGroupViewInStack() -> Bool {
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers
            where viewController.isKind(of: AddGroupListNameViewController.classForCoder()) {
                return true
            }
        }
        return false
    }

    func setInformations() {
        routeId = newBus.routeId!
        nodeId = newNode.nodeId!
        cityCode = newNode.cityCode!
        busNum = newBus.routeNo!
    }

    // MARK: - Actions
    // 완료 버튼 Actions
    @objc func doneButtonSelect() {
        if isArrivalOn {
            for myNode in nodeList {
                if case .arrival = myNode?.userSelected {
                    newBus.endNodeId = myNode?.code
                    newBus.endNodeName = myNode?.name
                }
            }
            newGroup.createDate = Date()
            newNode.group = newGroup
            newBus.node = newNode

            try? dataController.viewContext.save()
            let routeListViewController = RouteListViewController()
            routeListViewController.myGroup = newGroup
            routeListViewController.dataController = dataController
            self.navigationController?.pushViewController(routeListViewController, animated: true)
        }
    }

    // MARK: - Helpers
    func configureTableView() {
        arrivalTableView.delegate = self
        arrivalTableView.dataSource = self
        arrivalTableView.separatorStyle = .none
    }

    func configureNavigationBar() {
        let barDoneButton = UIBarButtonItem(customView: doneButton)
        navigationItem.rightBarButtonItem = barDoneButton
        navigationController?.navigationBar.tintColor = .white

    }

    func configureUI() {
        view.addSubview(busBadgeView)
        busBadgeView.widthAnchor
            .constraint(equalToConstant: busBadgeView.frame.width).isActive = true
        busBadgeView.heightAnchor.constraint(equalToConstant: busBadgeView.frame.height).isActive = true
        busBadgeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9).isActive = true
        busBadgeView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -17).isActive = true

        view.addSubview(arrivalTableView)
        arrivalTableView.topAnchor.constraint(equalTo: busBadgeView.bottomAnchor, constant: 5).isActive = true
        arrivalTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        arrivalTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        arrivalTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        view.addSubview(activityIndicator)
        activityIndicator.heightAnchor.constraint(equalToConstant: activityIndicator.bounds.height)
            .isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: activityIndicator.bounds.width)
            .isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    func setBusNodeList() {
        BusClient.getNodesListBody(
            city: cityCode,
            routeId: routeId,
            completion: handleRequestNodesTotalNumberResponse(response:error:))
    }

    // 전체 갯수 확인하는 네트워크 받으면 실행되는 콜백.
    func handleRequestNodesTotalNumberResponse(response: RouteNodesResponseBody?, error: Error?) {
        if let response = response {
            let iterater: Int
            print(response.totalCount)
            if Int(response.totalCount % response.numOfRows) == 0 {
                iterater = Int(response.totalCount / response.numOfRows)
            } else {
                iterater = Int(response.totalCount / response.numOfRows) + 1
            }
            pageCount = iterater
            for index in 1...iterater {
                BusClient.getNodeList(
                    city: cityCode,
                    routeId: routeId,
                    pageNo: String(index),
                    completion: handleRequestNodesListResponse(response:error:))
            }
        }
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
            // 출발정류장 인덱스부터 슬라이싱
            let slice = nodeList[departNodeIdx...]
            nodeList = Array(slice)

            activityIndicator.stopAnimating()
            arrivalTableView.reloadData()
        }
    }

    // API 리스트 -> ArrivalNodeModel 파싱
    func nodeInfoConversion(beforeNodes: [RouteNodesInfo]) {
        for (index, beforeNode) in beforeNodes.enumerated() {
            var nodeAttribute: NodeAttribute?
            var nodeSelected: NodeSelected?

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

            if beforeNode.nodeid == nodeId {
                nodeSelected = .depart(.onlyDep)
                departNodeIdx = index
            }

            nodeList.append(
                ArrivalNodeModel(
                    code: beforeNode.nodeid,
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
        // 완료 버튼 활성화 유뮤
        if indexPath.row == 0 {
            doneButton.setTitleColor(UIColor.duduGray, for: .normal)
            isArrivalOn = false
        } else {
            doneButton.setTitleColor(.white, for: .normal)
            isArrivalOn = true
        }

        // 선택한 셀의 인덱스를 바탕으로 전체 리스트의 .userSelected 속성 변경
        for index in nodeList.indices {
            if index == 0 {
                if indexPath.row == 0 {
                    nodeList[0]?.userSelected = .depart(.onlyDep)
                } else {
                    nodeList[0]?.userSelected = .depart(.notOnlyDep)
                }

                continue
            }

            if index < indexPath.row {
                nodeList[index]?.userSelected = .middle
            } else if index == indexPath.row {
                nodeList[index]?.userSelected = .arrival
            } else {
                nodeList[index]?.userSelected = .notSelected
            }
        }
        arrivalTableView.reloadData()
    }
}
