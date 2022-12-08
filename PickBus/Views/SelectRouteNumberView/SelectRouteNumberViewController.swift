//
//  SelectRouteNumberViewController.swift
//  PickBus
//
//  Created by Jaehwa Noh on 2022/11/10.
//

import UIKit

class SelectRouteNumberViewController: BackgroundViewController, UITableViewDataSource, UITableViewDelegate {
    private struct RouteNumberCellStruct: Hashable {
        let routeNumber: String
        let routeType: String
        let routeId: String
    }

    var selectedIndex = IndexPath(row: -1, section: 0)

    var dataController: DataController!
    var newNode: Node!
    var newGroup: Group!
    private var newBus: Bus!
    private var routeNumberCellInfos = [RouteNumberCellStruct]()
    private var isReady = false

    @IBOutlet weak var routeNumberTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true

        setNavigation()
        setBackground()

        newBus = Bus(context: dataController.viewContext)
        newBus.startNodeId = newNode.nodeId
        newBus.startNodeName = newNode.nodeNm

        //        print("hello: \(newNode.cityCode!), \(newNode.nodeId!)")
        self.navigationItem.title = .none
        BusClient.getAllRoutesFromNode(
            city: newNode.cityCode!,
            nodeId: newNode.nodeId!,
            completion: handleRequestAllRoutesInfoResponse(response:error:))
    }

    func setNavigation() {
        let backButton = UIBarButtonItem()
        backButton.tintColor = .white
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        let rightButton = UIBarButtonItem(
            title: "다음",
            style: .plain,
            target: self,
            action: #selector(pressButton(_:))
        )
        rightButton.tintColor = .white
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    func setBackground() {
        setTitleAndIndicator(titleText: "버스 번호를\n선택해 주세요", indicatorStep: .stepThree)

        contentView.addSubview(routeNumberTableView)
        //        routeNumberTableView.translatesAutoresizingMaskIntoConstraints = false
        routeNumberTableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        routeNumberTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        routeNumberTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        routeNumberTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

    }

    @objc func pressButton(_ sender: UIBarButtonItem) {

        let selectArrivalviewController = SelectArrivalViewController()

        selectArrivalviewController.newBus = newBus
        selectArrivalviewController.dataController = dataController
        selectArrivalviewController.newNode = newNode
        selectArrivalviewController.newGroup = newGroup

        self.navigationController?.pushViewController(selectArrivalviewController, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteNumberCell", for: indexPath)
        var cellContent = cell.defaultContentConfiguration()
        if routeNumberCellInfos.isEmpty {
            cellContent.text = "불러오는 중입니다."

        } else {
            let cellData = routeNumberCellInfos[indexPath.row]
            cellContent.text = "\(cellData.routeNumber) 번"
            cellContent.secondaryText = cellData.routeType

            if selectedIndex == indexPath {
                newBus.routeId = cellData.routeId
                newBus.routeNo = cellData.routeNumber
                cell.backgroundColor = UIColor(named: "duduBlue")
            } else {
                cell.backgroundColor = UIColor.clear
            }
        }

        cell.selectionStyle = .none
        cell.contentConfiguration = cellContent

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        selectedIndex = indexPath

        navigationItem.rightBarButtonItem?.isEnabled = isReady

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("run \(routeNumberCellInfos)")
        if routeNumberCellInfos.isEmpty {
            return 3
        } else {
            return routeNumberCellInfos.count
        }
    }

    func handleRequestAllRoutesInfoResponse(response: [AllRoutesFromNodeInfo], error: Error?) {
        routeNumberCellInfos = response.map { res in
            RouteNumberCellStruct(
                routeNumber: res.routeno.stringValue,
                routeType: res.routetp,
                routeId: res.routeid)
        }
        routeNumberCellInfos = Array(Set(routeNumberCellInfos))
        routeNumberCellInfos.sort {
            $0.routeNumber < $1.routeNumber
        }
        routeNumberTableView.reloadData()
        //        for test in response {
        //            print(test)
        //        }

        guard error == nil else {
            print("error")
            print(error?.localizedDescription ?? "")
            isReady = false
            return
        }
        isReady = true
        print("response")
    }
}
