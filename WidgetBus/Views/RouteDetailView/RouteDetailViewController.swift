//
//  RouteDetailViewController.swift
//  WidgetBus
//
//  Created by 김혜수 on 2022/11/12.
//

import UIKit

enum BoardingStatus {
    case onBoard
    case getOff
}

class RouteDetailViewController: UIViewController {

    @IBOutlet weak var busNumberLabel: UILabel!
    @IBOutlet weak var startStationLabel: UILabel!
    @IBOutlet weak var endStationLabel: UILabel!
    @IBOutlet weak var busTimeInfoLabel: UILabel!

    @IBOutlet weak var routeView: UIView!
    @IBOutlet weak var routeDetailTableView: UITableView!

    @IBOutlet weak var boardingStateButton: UIButton!

    var boardingStatus: BoardingStatus = .onBoard

    @IBAction func tapBoardingStateButton(_ sender: UIButton) {
        switch self.boardingStatus {
        case .onBoard:
            self.boardingStatus = .getOff
            self.boardingStateButton.isSelected = true
        case .getOff:
            self.boardingStatus = .onBoard
            self.boardingStateButton.isSelected = false
        }
    }

    let retryButoon = UIButton(frame: CGRect(x: 318, y: 707, width: 55, height: 55))

    override func viewDidLoad() {
        super.viewDidLoad()

        routeView.clipsToBounds = true
        routeView.layer.cornerRadius = 30
        routeView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)

        self.routeDetailTableView.dataSource = self
        self.routeDetailTableView.delegate = self
        busNumberLabel.text = "1000"

        retryButoon.backgroundColor = .blue
        retryButoon.layer.cornerRadius = 0.5 * retryButoon.bounds.width
        self.view.addSubview(retryButoon)
        self.configureBoardingTapButton()
    }

    func configureBoardingTapButton() {

        let boardText = "탑승"
        let boardAttribute = NSMutableAttributedString(string: boardText)
        let font = UIFont(name: "Helvetica-Bold", size: 40)
        boardAttribute.addAttribute(
            NSAttributedString.Key.font,
            value: font as Any,
            range: NSRange(location: 0, length: boardText.count)
        )
        self.boardingStateButton.setAttributedTitle(boardAttribute, for: .normal)

        let getOffText = "탑승취소"
        let getOffAttribute = NSMutableAttributedString(string: getOffText)
        getOffAttribute.addAttribute(
            NSAttributedString.Key.font,
            value: font as Any,
            range: NSRange(location: 0, length: getOffText.count)
        )
        self.boardingStateButton.setAttributedTitle(getOffAttribute, for: .selected)
    }
}

extension RouteDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "routeDetailCell",
            for: indexPath) as! RouteDetailTableViewCell
        cell.busStationLabel.text = "포스텍"
        cell.routeLineView.backgroundColor = .gray
        cell.busView.isHidden = false
        cell.busTimeLabel.layer.masksToBounds = true
        cell.busTimeLabel.layer.cornerRadius = 6.5

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 14
    }
}

extension RouteDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
