//
//  RouteListViewController.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/10.
//

import UIKit

class RouteListViewController: UIViewController {

    // 셀,헤더,푸터 높이
    let headerHeight: CGFloat = 36
    let footerHeight: CGFloat = 15
    let routeCellHeight: CGFloat = 52
    let addRouteCellHeight: CGFloat = 78

    // 루트테이블 뷰
    private let routeTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.sectionHeaderTopPadding = 25
        table.backgroundColor = .clear
        table.separatorStyle = .none

        // 루트 셀 등록
        table.register(RouteTableViewCell.self, forCellReuseIdentifier: RouteTableViewCell.identifier)

        // 루트추가 셀 등록
        table.register(AddRouteTableViewCell.self, forCellReuseIdentifier: AddRouteTableViewCell.identifier)

        // 헤더 등록
        table.register(RouteTableHeader.self, forHeaderFooterViewReuseIdentifier: RouteTableHeader.identifier)

        // 푸터 등록
        table.register(RouteTableFooter.self, forHeaderFooterViewReuseIdentifier: RouteTableFooter.identifier)

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
            routeTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            routeTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - UITableViewDelegate
extension RouteListViewController: UITableViewDelegate {
}

// MARK: - UITableViewDataSource
extension RouteListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RouteTableHeader.identifier)
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: RouteTableFooter.identifier)
        return footer
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 2 ? 0 : headerHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 2 ? 0 : footerHeight
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 2 ? 1 : 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 2 ? addRouteCellHeight : routeCellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: AddRouteTableViewCell.identifier,
                for: indexPath) as! AddRouteTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: RouteTableViewCell.identifier,
                for: indexPath) as! RouteTableViewCell
            return cell
        }
    }
}
