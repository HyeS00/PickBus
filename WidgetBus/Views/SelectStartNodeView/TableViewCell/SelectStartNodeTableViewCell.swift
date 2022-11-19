//
//  SelectStartNodeTableViewCell.swift
//  WidgetBus
//
//  Created by 김민재 on 2022/11/15.
//

import UIKit
import MapKit

class SelectStartNodeTableViewCell: UITableViewCell {

    @IBOutlet weak var nodeName: UILabel!
    @IBOutlet weak var nodeDirection: UILabel!
    @IBOutlet weak var nodeDistance: UILabel!

    @IBOutlet weak var mapView: MKMapView!

    static func nib() -> UINib {
        return UINib(nibName: "SelectStartNodeTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mapView.mapType = MKMapType.standard
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    // MARK: 셀 확장 설정
    func settingData(isClicked: Bool) {
        if isClicked {
            mapView.isHidden = false
            self.backgroundColor = .duduBlue
        } else {
            mapView.isHidden = true
            self.backgroundColor = .clear
        }
    }

}
