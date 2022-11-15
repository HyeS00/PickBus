//
//  RouteListViewController.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/10.
//

import UIKit

class RouteListViewController: UIViewController {

    // 임시 설정 버튼
    private lazy var editButton: UIButton = {
            let button = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
            button.setTitle("Edit", for: .normal)
            button.backgroundColor = .green
            button.addTarget(self, action: #selector(pressedEditButton(_ :)), for: .touchUpInside)
            return button
        }()

    // 더미 데이터
    let busStops = BusData.busStops

    // 셀,헤더,푸터 높이
    let headerHeight: CGFloat = 36
    let footerHeight: CGFloat = 15
    let routeCellHeight: CGFloat = 52
    let addRouteCellHeight: CGFloat = 78

    // 루트테이블 뷰
    private let routeTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
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

        // 루트 셀 등록
        table.register(RouteTableViewCell.self, forCellReuseIdentifier: RouteTableViewCell.identifier)

        // 루트추가 셀 등록
        table.register(AddRouteTableViewCell.self, forCellReuseIdentifier: AddRouteTableViewCell.identifier)

        // 헤더 등록
        table.register(RouteTableHeader.self, forHeaderFooterViewReuseIdentifier: RouteTableHeader.identifier)

        // 푸터 등록
        table.register(RouteTableFooter.self, forHeaderFooterViewReuseIdentifier: RouteTableFooter.identifier)

        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .duduDeepBlue
        setupLayout()
        setupConstraints()
        routeTableView.reloadData()
        routeTableView.delegate = self
        routeTableView.dataSource = self
    }

    private func setupLayout() {
        self.view.addSubview(routeTableView)
        self.view.addSubview(editButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            routeTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            routeTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            routeTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            routeTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        ])
    }

    // 임시 설정 버튼 함수
        @objc private func pressedEditButton(_ sender: UIButton!) {
            print("pressed editButton")
            if self.routeTableView.isEditing {
                print("수정모드yes")
                self.editButton.setTitle("Edit", for: .normal)
                self.routeTableView.setEditing(false, animated: true)

            } else {
                print("수정모드no")
                self.editButton.setTitle("Done", for: .normal)
                self.routeTableView.setEditing(true, animated: true)
            }
        }
}

// MARK: - UITableViewDelegate
extension RouteListViewController: UITableViewDelegate {
}

// MARK: - UITableViewDataSource
extension RouteListViewController: UITableViewDataSource {

    // 헤더
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: RouteTableHeader.identifier) as! RouteTableHeader
        header.busStopLabel.text = busStops[section].name
        return header
    }

    // 푸터
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: RouteTableFooter.identifier)
        return footer
    }

    // 헤더 높이 - 마지막 섹션 헤더 높이는 0
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == busStops.count - 1 ? 0 : headerHeight
    }

    // 푸터 높이 - 마지막 섹션 푸터 높이는 0
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == busStops.count - 1 ? 0 : footerHeight
    }

    // 섹션 수
    func numberOfSections(in tableView: UITableView) -> Int {
        busStops.count
    }

    // 셀 수 - 마지막 섹션의 셀 수는 1 (루트 추가 셀)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == busStops.count - 1 ? 1 : busStops[section].routes.count
    }

    // 셀 높이 - 마지막 섹션의 셀이면 루트 추가 셀의 높이 적용
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == busStops.count - 1 ? addRouteCellHeight : routeCellHeight
    }

    // 셀 정의 - 마지막 섹션이면 루트 추가 셀 적용 / 기본 섹션이면 루트 셀 적용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == busStops.count - 1 {
            // 마지막 섹션
            let cell = tableView.dequeueReusableCell(
                withIdentifier: AddRouteTableViewCell.identifier,
                for: indexPath) as! AddRouteTableViewCell
            return cell
        } else {
            // 기본 섹션
            let cell = tableView.dequeueReusableCell(
                withIdentifier: RouteTableViewCell.identifier,
                for: indexPath) as! RouteTableViewCell
            let route = busStops[indexPath.section].routes[indexPath.row]
            cell.selectionStyle = .none
            cell.setCell(
                busNumber: route.busNumber,
                busRemainingTime: route.busRemainingTime,
                nextBusRemainingTime: route.nextBusRemainingTimeLabel)
            return cell
        }
    }
}
