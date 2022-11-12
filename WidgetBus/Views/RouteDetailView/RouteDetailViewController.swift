//
//  RouteDetailViewController.swift
//  WidgetBus
//
//  Created by 김혜수 on 2022/11/12.
//

import UIKit

class RouteDetailViewController: UIViewController {

    @IBOutlet weak var busNumberLabel: UILabel!
    @IBOutlet weak var startStationLabel: UILabel!
    @IBOutlet weak var endStationLabel: UILabel!
    @IBOutlet weak var busTimeInfoLabel: UILabel!

    @IBOutlet weak var routeView: UIView!
    @IBOutlet weak var routeDetailTableView: UITableView!

    @IBOutlet weak var boardingStateButton: UIButton!

    @IBAction func tapBoardingStateButton(_ sender: UIButton) {
        
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
    }
}

extension RouteDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeDetailCell", for: indexPath) as! RouteDetailTableViewCell
        cell.busStationLabel.text = "포스텍"
        cell.routeLineView.backgroundColor = .gray
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension RouteDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
