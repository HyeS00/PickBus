//
//  RouteListViewController.swift
//  PickBus
//
//  Created by KoJeongseok on 2022/11/10.
//

import UIKit
import CoreData

final class RouteListViewController: UIViewController {

    // 코어 데이터
    var dataController: DataController!
    var myGroup: Group!

    // API 횟수
    private var nodeCount: Int = 0

    // Timer 객체 생성
    private var apiTimer: Timer? = Timer()

    // 셋 데이터
    private var nodeIdDic = [String: Int]()
    private var arriveBusStop = [[Int]]()
    private var arriveArray = [[Int?]]()
    private var nodeArray = [Node]()
    private var busArray = [[Bus]]()

    // 테이블뷰 타이틀 위치
    private var defautY: Double?

    // 셀 높이
    private let routeHeaderCellHeight: CGFloat = 35
    private let addRouteCellHeight: CGFloat = 78
    private let routeCellHeight: CGFloat = 50

    // 루트테이블 뷰
    private let routeTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false
        table.sectionHeaderTopPadding = 25
        table.backgroundColor = .clear
        table.separatorStyle = .none

        // 그림자
        table.layer.shadowOffset = .init(width: 0, height: 2)
        table.layer.shadowColor = UIColor.black.cgColor
        table.layer.masksToBounds = false
        table.layer.shadowOpacity = 0.2
        table.layer.shadowRadius = 10

        // 테이블 뷰 요소 등록 - 타이틀, 정류장, 루트, 루트추가
        table.register(TitleHeader.self, forHeaderFooterViewReuseIdentifier: TitleHeader.identifier)
        table.register(AddRouteCell.self, forCellReuseIdentifier: AddRouteCell.identifier)
        table.register(BusStopCell.self, forCellReuseIdentifier: BusStopCell.identifier)
        table.register(RouteCell.self, forCellReuseIdentifier: RouteCell.identifier)

        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .duduDeepBlue

        setupData()
        requestArriveInfo()
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

        self.extendedLayoutIncludesOpaqueBars = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        apiTimer?.invalidate()
        apiTimer = nil
        navigationController?.navigationBar.barTintColor = .clear
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .duduDeepBlue
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
            self.routeTableView.setEditing(false, animated: false)
            self.routeTableView.reloadData()
        } else {
            navigationItem.rightBarButtonItem?.title = "완료"
            self.routeTableView.setEditing(true, animated: false)
            self.routeTableView.reloadData()
        }
    }

    // Timer가 API request 함수 호출
    @objc private func updatedTimer(sender: Timer) {
        requestArriveInfo()
    }

    // request
    private func requestArriveInfo() {
        if !nodeArray.isEmpty {
            for node in nodeArray {
                BusClient.getArriveList(
                    city: node.cityCode!,
                    nodeId: node.nodeId!,
                    completion: fetchArriveInfo(response:error:)
                )
            }
        }
    }

    // fetch
    func fetchArriveInfo(response: [ArriveInfoResponseArriveInfo], error: Error?) {
        if error == nil {
            // 성공
            // 수정할 부분 값이 nil인 경우 처리
            guard let nodeIndex = nodeIdDic[response[0].nodeid] else { fatalError() }
            for busIndex in busArray[nodeIndex].indices {
                guard let myRouteNo = busArray[nodeIndex][busIndex].routeNo else {
                    // 정보 없음 시, 뒤돌아가면 에러 발생해서 주석 처리.
//                    fatalError()
                    return
                }
                if let fetchBusInfo = response.filter({
                    $0.routeno.stringValue == String(myRouteNo)
                }).first {
                    // 버스 정보가 있음
                    arriveArray[nodeIndex][busIndex] = fetchBusInfo.arrtime
                } else {
                    // 버스 정보가 없음
                    print("도착정보가 없습니다.")
                }

            }
            nodeCount += 1
        } else {
            // 실패
            nodeCount += 1
        }
        if nodeCount == nodeArray.count {
            nodeCount = 0
            routeTableView.reloadData()
        }
    }

    private func secToMin(sec: Int?) -> String {
        if sec == nil {
            return "정보없음"
        } else {
            return String(sec! / 60) + "분"
        }
    }

    func toRouteDetilView(indexPath: IndexPath, bordingStatus: BoardingStatus) {
        let nodeInfo = nodeArray[indexPath.section]
        let busInfo = busArray[indexPath.section][indexPath.row - 1]

        guard let nodeId = nodeInfo.nodeId else { fatalError() }
        guard let cityCode = nodeInfo.cityCode else { fatalError() }
        guard let routeId = busInfo.routeId else { fatalError() }
        guard let startNodeId = busInfo.startNodeId else { fatalError() }
        guard let endNodeId = busInfo.endNodeId else { fatalError() }
        guard let routeNo = busInfo.routeNo else { fatalError() }

        let storyboard = UIStoryboard(name: "RouteDetailView", bundle: nil)
        let routeDetailView =
        storyboard.instantiateViewController(
            withIdentifier: "RouteDetailView") as! RouteDetailViewController
        routeDetailView.routeNo = routeNo
        routeDetailView.boardingStatus = bordingStatus
        routeDetailView.nodeId = nodeId
        routeDetailView.cityCode = Int(cityCode)!
        routeDetailView.routeId = routeId
        routeDetailView.route = RouteModel(startNodeId: startNodeId, endNodeId: endNodeId)
        self.navigationController?.pushViewController(routeDetailView, animated: true)
    }

    // 그룹 삭제 버튼
    @objc private func pressedDeleteTitleButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "정말로 그룹을 삭제 하시겠습니까?", message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in

            // 여기 타입 확인 필요 !!!!
            let navigationStack = self.navigationController?.viewControllers
            let groupListVC = navigationStack![navigationStack!.count-2] as! GroupListViewContoller
            groupListVC.setCellInit()

            // 루트뷰로 가게 수정해야함
            self.navigationController?.popToRootViewController(animated: true)
            self.deleteGroup()
        }
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(delete)
        alert.addAction(cancle)
        present(alert, animated: true)
    }

    // 그룹 수정 버튼
    @objc private func pressedEditTitleButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "그룹이름 수정하기", message: nil, preferredStyle: .alert)
        let enter = UIAlertAction(title: "확인", style: .default) { _ in
            if let newName = alert.textFields?[0].text {
                self.editGroupName(newName: newName)
                self.routeTableView.reloadData()
            }

        }
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(enter)
        alert.addAction(cancle)
        alert.addTextField { textField in
            textField.placeholder = self.myGroup.name
        }
        self.present(alert, animated: true, completion: nil)
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
            // 버스 셀 선택 - 디테일뷰
            toRouteDetilView(indexPath: indexPath, bordingStatus: .getOff)
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
        header.deleteButton.addTarget(
            self,
            action: #selector(pressedDeleteTitleButton(_ :)),
            for: .touchUpInside
        )
        header.editButton.addTarget(
            self,
            action: #selector(pressedEditTitleButton(_ :)),
            for: .touchUpInside
        )
        header.isEditinMode = !routeTableView.isEditing
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
        section == nodeArray.count ? 1 : busArray[section].count + 1
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
                cell.selectionStyle = .none
                cell.closure = {
                    self.toRouteDetilView(indexPath: indexPath, bordingStatus: .onBoard)
                }
                cell.busNumberLabel.text = busArray[indexPath.section][indexPath.row - 1].routeNo
                cell.arrTime = secToMin(
                    sec: arriveArray[indexPath.section][indexPath.row - 1])
                return cell
            }
        }
    }
}

// MARK: - CoreData
extension RouteListViewController: NSFetchedResultsControllerDelegate {
    // 정류장 로드
    private func loadNodes() {
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

    // 버스 로드
    private func loadBuses(myNode: Node) {
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

    // setup
    private func setupData() {
        loadNodes()
        for num in nodeArray.indices {
            loadBuses(myNode: nodeArray[num])
            nodeIdDic[nodeArray[num].nodeId!] = num
            arriveArray.append(Array(repeating: nil, count: busArray[num].count))
        }
    }

    // 그룹 삭제
    private func deleteGroup() {
        guard let groupToDelete = myGroup else { fatalError() }
        dataController.viewContext.delete(groupToDelete)
        try? dataController.viewContext.save()
    }

    // 정류장 삭제
    private func deleteNode(section: Int) {
        let nodeToDelete = nodeArray[section]
        nodeArray.remove(at: section)
        dataController.viewContext.delete(nodeToDelete)
        try? dataController.viewContext.save()
    }

    // 버스 삭제
    private func deleteBus(section: Int, row: Int) {
        let busToDelete = busArray[section][row]
        busArray[section].remove(at: row)
        dataController.viewContext.delete(busToDelete)
        try? dataController.viewContext.save()
    }

    // 그룹 수정
    private func editGroupName(newName: String) {
        myGroup.name = newName
        dataController.viewContext.refresh(myGroup, mergeChanges: true)
        try? dataController.viewContext.save()
    }
}
