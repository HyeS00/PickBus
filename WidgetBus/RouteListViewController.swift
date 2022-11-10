//
//  RouteListViewController.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/10.
//

import UIKit

class RouteListViewController: UIViewController {

    // 루트테이블 뷰
    private let routeTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)

        // 루트 셀 등록
        table.register(RouteTableViewCell.self, forCellReuseIdentifier: RouteTableViewCell.identifier)

        // 루트추가 셀 등록
        table.register(AddRouteTableViewCell.self, forCellReuseIdentifier: AddRouteTableViewCell.identifier)

        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        routeTableView.delegate = self
        routeTableView.dataSource = self
    }

    private func setupLayout() {
        self.view.addSubview(routeTableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            routeTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120),
            routeTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            routeTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            routeTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate
extension RouteListViewController: UITableViewDelegate {
}

// MARK: - UITableViewDataSource
extension RouteListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: RouteTableViewCell.identifier, for: indexPath) as! RouteTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddRouteTableViewCell.identifier, for: indexPath) as! AddRouteTableViewCell
            return cell
        }
    }
}
