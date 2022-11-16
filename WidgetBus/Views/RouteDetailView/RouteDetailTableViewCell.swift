//
//  RouteDetailTableViewCell.swift
//  WidgetBus
//
//  Created by 김혜수 on 2022/11/12.
//

import UIKit

class RouteDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var routePointImageView: UIImageView!
    @IBOutlet weak var routeLineView: UIView!
    @IBOutlet weak var busStationLabel: UILabel!

    @IBOutlet weak var busView: UIStackView!
    @IBOutlet weak var busTimeLabel: UILabel!
    @IBOutlet weak var busImageView: UIImageView!
}
