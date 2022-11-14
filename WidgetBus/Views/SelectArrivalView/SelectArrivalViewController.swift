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

    private let arrivalTableView: UITableView =  {
        let tableView = UITableView()
        tableView.register(ArrivalTableViewCell.self, forCellReuseIdentifier: ArrivalTableViewCell.identifier)
        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        nodeList = setDummyBusNodeList()

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

    // 버스노선 더미 데이터
    func setDummyBusNodeList() -> [ArrivalNodeModel] {
        let nodeList: [ArrivalNodeModel] = [
            ArrivalNodeModel(name: "포스텍", attribute: .nomal, userSelected: .departure),
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
}
extension SelectArrivalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension SelectArrivalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = arrivalTableView.dequeueReusableCell(withIdentifier: ArrivalTableViewCell.identifier, for: indexPath) as? ArrivalTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(nodeInfo: nodeList[indexPath.row]!)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in nodeList.indices {
            /*
            if indexPath.row == 0 {
                // 출발 노드 경로 색상을 바꿔줘야한다.
            } else {
                //
            }
             */

            if index == 0 {
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
