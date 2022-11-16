//
//  SelectStartNodeViewController.swift
//  WidgetBus
//
//  Created by 김민재 on 2022/11/15.
//

import UIKit

class SelectStartNodeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var answerFilterDatasource: Bool = false
    var selectedTableViewCell: IndexPath?

    @IBOutlet weak var tableView: UITableView!

    var nodeName: [String] = [
        "정류장1", "정류장2", "정류장3", "정류장4", "정류장5", "정류장6", "정류장7", "정류장8", "정류장9", "정류장10"
    ]
    var nodeDirection: [String] = [
        "정류장2방면", "정류장3방면", "정류장4방면", "정류장5방면", "정류장6방면", "정류장7방면", "정류장8방면", "정류장9방면", "정류장10방면", "정류장1방면"
    ]
    var nodeDistance: [String] = [
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        defaultTableViewSetting()
    }

    // MARK: 테이블
    func defaultTableViewSetting() {
        self.tableView.register(
            SelectStartNodeTableViewCell.nib(),
            forCellReuseIdentifier: SelectStartNodeTableViewCell.identifier
        )

        self.tableView.delegate = self
        self.tableView.dataSource = self
//        self.tableView.separatorStyle = .none
//        self.tableView.separatorInset = .zero

        self.tableView.rowHeight = UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodeName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SelectStartNodeTableViewCell.identifier,
            for: indexPath
        ) as! SelectStartNodeTableViewCell

        cell.nodeName.text = nodeName[indexPath.row]
        cell.nodeDirection.text = nodeDirection[indexPath.row]
        cell.nodeDistance.text = nodeDistance[indexPath.row]
        cell.settingData(isClicked: answerFilterDatasource)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let prevSelectedTableViewCell = self.selectedTableViewCell {
            if prevSelectedTableViewCell != indexPath {
                self.answerFilterDatasource = false
                self.tableView.reloadRows(at: [prevSelectedTableViewCell], with: .automatic)
            }
        }

        self.answerFilterDatasource.toggle()
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        self.selectedTableViewCell = indexPath

//        self.performSegue(withIdentifier: "showHomeDetailView", sender: self)
//
//        navigationController?.setNavigationBarHidden(false, animated: true)
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? HomeDetailViewController {
//            destination.dogDataModel = dogDataModels[(table.indexPathForSelectedRow?.row)!]
//            table.deselectRow(at: table.indexPathForSelectedRow!, animated: true)
//        }
//    }

}
