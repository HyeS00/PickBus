//
//  SelectStartNodeTableViewCell.swift
//  WidgetBus
//
//  Created by 김민재 on 2022/11/15.
//

import UIKit

class ExpandingTableViewCellContent {

    var expanded: Bool

    init() {
        self.expanded = false
    }
}

class SelectStartNodeTableViewCell: UITableViewCell {

    @IBOutlet weak var nodeName: UILabel!
    @IBOutlet weak var nodeDirection: UILabel!
    @IBOutlet weak var nodeDistance: UILabel!

    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var mapViewHeightConstraint: NSLayoutConstraint!

    static func nib() -> UINib {
        return UINib(nibName: "SelectStartNodeTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: 셀 확장 설정
    func settingData(isClicked: ExpandingTableViewCellContent) {
        if isClicked.expanded == true {
            self.mapView.isHidden = false
            self.mapViewHeightConstraint.constant = 290
        } else {
            self.mapViewHeightConstraint.constant = 0
            self.mapView.isHidden = true
        }
    }

}
