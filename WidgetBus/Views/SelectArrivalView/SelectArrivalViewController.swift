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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        nodeList = setDummyBusNodeList()

        arrivalTableView.delegate = self
        arrivalTableView.dataSource = self

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
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = arrivalTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "dd"
        return cell
    }
}
