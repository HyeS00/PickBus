//
//  RouteListViewController.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/10.
//

import UIKit
import CoreData

final class RouteListViewController: UIViewController, NSFetchedResultsControllerDelegate {

    // API 횟수
    private var nodeCount: Int = 0

    // Timer 객체 생성
    private var apiTimer = Timer()

    // 코어 데이터
    var dataController: DataController!
    var myGroup: Group!

    // 셋 데이터
    var nodeArray = [Node]() // 정류장 배열
    var busArray = [[Bus]]() // 버스 배열
    var arriveArray = [[Int?]]() // 남은시간 배열
    var arriveBusstrop = [[Int]]() // 남은 정류장 배열
    var nodeIdDic = [String: Int]() // 정류장 인덱스 딕셔너리

    // 테이블뷰 타이틀 위치
    var defautY: Double?

    fileprivate func loadNodes() {
        let fetchRequest: NSFetchRequest<Node> = Node.fetchRequest()
        let predicate = NSPredicate(format: "group == %@", myGroup)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "nodeId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            nodeArray = try dataController.viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching node data from context \(error)")
        }
    }

    fileprivate func loadBuses(myNode: Node) {
        let fetchRequest: NSFetchRequest<Bus> = Bus.fetchRequest()
        let predicate = NSPredicate(format: "node == %@", myNode)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "routeId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let buses = try dataController.viewContext.fetch(fetchRequest)
            busArray.append(buses)
        } catch {
            print("Error fatching bus data from context \(error)")
        }
    }

    fileprivate func setupData() {
        loadNodes()

        for num in nodeArray.indices {
            loadBuses(myNode: nodeArray[num])
            nodeIdDic[nodeArray[num].nodeId!] = num
            arriveArray.append(Array(repeating: nil, count: busArray[num].count))
        }
    }

    // 셀 높이
    private let routeHeaderCellHeight: CGFloat = 35
    private let routeCellHeight: CGFloat = 50
    private let addRouteCellHeight: CGFloat = 78

    // 루트테이블 뷰
    private let routeTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.showsVerticalScrollIndicator = false
        table.sectionHeaderTopPadding = 25
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        // 그림자
        table.layer.masksToBounds = false
        table.layer.shadowColor = UIColor.black.cgColor
        table.layer.shadowOpacity = 0.2
        table.layer.shadowRadius = 10
        table.layer.shadowOffset = .init(width: 0, height: 2)

        // 테이블 뷰 요소 등록 - 타이틀, 정류장, 루트, 루트추가
        table.register(TitleHeader.self, forHeaderFooterViewReuseIdentifier: TitleHeader.identifier)
        table.register(BusStopCell.self, forCellReuseIdentifier: BusStopCell.identifier)
        table.register(RouteCell.self, forCellReuseIdentifier: RouteCell.identifier)
        table.register(AddRouteCell.self, forCellReuseIdentifier: AddRouteCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .duduDeepBlue

        // 코어데이터 셋
        setupData()

        // 타이머 실행전 1회 api 호출
        requestArriveInfo()

        // 타이머 설정 - 30초마다 api 호출
        apiTimer = Timer.scheduledTimer(
            timeInterval: 30,
            target: self,
            selector: #selector(updatedTimer(sender:)),
            userInfo: nil, repeats: true
        )

        setupNavigationBar()
        setupLayout()
        setupConstraints()
        routeTableView.reloadData()
        routeTableView.delegate = self
        routeTableView.dataSource = self
    }

    private func setupNavigationBar() {
        // 타이틀 설정
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.clear]

        // back 버튼
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(pressedBackButton(_ :))
        )
        // 편집 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "편집",
            style: .plain,
            target: self,
            action: #selector(pressedEditButton(_ :))
        )
        navigationController?.navigationBar.tintColor = .white
    }

    private func setupLayout() {
        self.view.addSubview(routeTableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            // 루트테이블뷰
            routeTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            routeTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            routeTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            routeTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    // 뒤로가기
    @objc private func pressedBackButton(_ sender: UIButton!) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    // 편집하기
    @objc private func pressedEditButton(_ sender: UIButton!) {
        if self.routeTableView.isEditing {
            navigationItem.rightBarButtonItem?.title = "편집"
            self.routeTableView.setEditing(false, animated: true)
            self.routeTableView.reloadData()
        } else {
            navigationItem.rightBarButtonItem?.title = "완료"
            self.routeTableView.setEditing(true, animated: true)
        }
    }

    // 버스정보 API 호출
    @objc func updatedTimer(sender: Timer) {
        // API를 호출함수 호출
        print("30초가 경과하여 updateRouteInfo 함수가 실행되었습니다.")
        requestArriveInfo()
    }

    func requestArriveInfo() {
        for node in nodeArray {
            BusClient.getArriveList(
                city: node.cityCode!,
                nodeId: node.nodeId!,
                completion: fetchArriveInfo(response:error:)
            )
        }
    }

    func fetchArriveInfo(response: [ArriveInfoResponseArriveInfo], error: Error?) {
        if error == nil {
            // 성공
            guard let nodeIndex = nodeIdDic[response[0].nodeid] else { fatalError() }
            for busIndex in busArray[nodeIndex].indices {

                guard let fetchBusInfo = response.filter({ $0.routeno.stringValue == String(busArray[nodeIndex][busIndex].routeNo!) }).first else { fatalError() }
//                let newRouteInfo = response.filter {
//                    $0.routeno.stringValue == String(busArray[nodeIndex][busIndex].routeNo!) }.first
                arriveArray[nodeIndex][busIndex] = fetchBusInfo.arrtime
                // 두번째 정류장 받아올 때
            }
            nodeCount += 1
        } else {
            // 실패
            nodeCount += 1
        }

        if nodeCount == nodeArray.count {
            print("완료")
            routeTableView.reloadData()
            nodeCount = 0
        } else {
            print("미완료")
        }
    }

    func secToMin(sec: Int?) -> String {
        if sec == nil {
            return "정보없음"
        } else {
            return String(sec! / 60) + "분"
        }
    }

    func deleteNode(section: Int) {
        let nodeToDelete = nodeArray[section]
        nodeArray.remove(at: section)
        dataController.viewContext.delete(nodeToDelete)
        try? dataController.viewContext.save()
    }

    func deleteBus(section: Int, row: Int) {
        let busToDelete = busArray[section][row]
        busArray[section].remove(at: row)
        dataController.viewContext.delete(busToDelete)
        try? dataController.viewContext.save()
    }
}

// MARK: - UITableViewDelegate
extension RouteListViewController: UITableViewDelegate {

    // 섹션, 루트 삭제 기능

        func tableView(
            _ tableView: UITableView,
            commit editingStyle: UITableViewCell.EditingStyle,
            forRowAt indexPath: IndexPath
        ) {
            if busArray[indexPath.section].count == 1 {
                // 섹션 제거
                deleteNode(section: indexPath.section)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            } else {
                // 루트 제거
                deleteBus(section: indexPath.section, row: indexPath.row - 1)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }

    // 정류장 셀은 삭제 불가 기능
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.row == 0 ? false : true
    }

    // 스크롤 위치변화에 따른 네비게이션 타이틀 표시
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if defautY == nil {
            defautY = routeTableView.contentOffset.y
        } else {
            if defautY! - routeTableView.contentOffset.y < -52 {
                self.navigationController?.navigationBar.titleTextAttributes = [
                    .foregroundColor: UIColor.white
                ]
                self.title = myGroup.name
            } else {
                self.navigationController?.navigationBar.titleTextAttributes = [
                    .foregroundColor: UIColor.clear
                ]
                self.title = .none
            }
        }
    }

    // 셀 선택
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 루트추가 셀 선택
        if indexPath.section == busArray.count {
            let storyboard = UIStoryboard(name: "SelectStartNodeView", bundle: nil)
            let selectStartNodeViewController =
            storyboard.instantiateViewController(
                withIdentifier: "SelectStartNodeView") as! SelectStartNodeViewController
            selectStartNodeViewController.dataController = dataController
            selectStartNodeViewController.newGroup = myGroup
            self.navigationController?.pushViewController(selectStartNodeViewController, animated: true)
        } else {
            // 버스 셀 선택
        }
    }
}

// MARK: - UITableViewDataSource
extension RouteListViewController: UITableViewDataSource {

    // 헤더
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TitleHeader.identifier) as! TitleHeader
        header.busStopLabel.text = myGroup.name
        return header
    }

    // 헤더 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 50 : 0
    }

    // 섹션 수
    func numberOfSections(in tableView: UITableView) -> Int {
        nodeArray.count + 1
    }

    // 셀 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == nodeArray.count ? 1 : busArray.count + 1
    }

    // 셀 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == nodeArray.count ?
        addRouteCellHeight : indexPath.row == 0 ?
        routeHeaderCellHeight : routeCellHeight
    }

    // 셀 정의 - 마지막 섹션이면 루트 추가 셀 적용 / 기본 섹션이면 루트 셀 적용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == nodeArray.count {
            // 마지막 섹션
            let cell = tableView.dequeueReusableCell(
                withIdentifier: AddRouteCell.identifier,
                for: indexPath) as! AddRouteCell
            return cell
        } else {
            // 기본 섹션
            if indexPath.row == 0 {
                // 정류장 셀
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: BusStopCell.identifier,
                    for: indexPath) as! BusStopCell
                cell.busStopLabel.text = nodeArray[indexPath.section].nodeNm
                cell.selectionStyle = .none
                return cell
            } else {
                // 기본 셀
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: RouteCell.identifier,
                    for: indexPath) as! RouteCell
                cell.busNumberLabel.text = busArray[indexPath.section][indexPath.row - 1].routeNo
                cell.arrTime = secToMin(
                    sec: arriveArray[indexPath.section][indexPath.row - 1])
                return cell
            }
        }
    }
}
