//
//  SelectArrivalViewController.swift
//  WidgetBus
//
//  Created by LeeJaehoon on 2022/11/14.
//

import UIKit

class SelectArrivalViewController: UIViewController {

    // MARK: - Properties

    private let arrivalTableView: UITableView =  {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        arrivalTableView.delegate = self
        arrivalTableView.dataSource = self

        configureUI()

    }

    // MARK: - Helpers
    func configureUI() {
        view.addSubview(arrivalTableView)
        arrivalTableView.frame = view.bounds
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
