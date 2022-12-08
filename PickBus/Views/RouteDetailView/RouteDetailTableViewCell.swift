//
//  RouteDetailTableViewCell.swift
//  PickBus
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

    @IBOutlet weak var busView2: UIStackView!
    @IBOutlet weak var busTimeLabel2: UILabel!
    @IBOutlet weak var busImageView2: UIImageView!
    @IBOutlet weak var busImageBoundView2: UIView!
    @IBOutlet weak var busImageLabel2: UILabel!

    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak var highlightLabel: UILabel!
}
