//
//  ArrivalTableViewCell.swift
//  WidgetBus
//
//  Created by LeeJaehoon on 2022/11/14.
//

import UIKit

class ArrivalTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "arrivalTableViewCell"

    private let nodeHighlightImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let routeNodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down.circle")
        imageView.tintColor = UIColor.gray
        return imageView
    }()

    private let routeNodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)

        return label
    }()

    private let routeLineImageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nodeHighlightImageView.image = nil
        routeLineImageView.image = nil

        routeNodeImageView.tintColor = .gray
        routeLineImageView.tintColor = .gray
    }

    // MARK: - Helpers
    public func configure(nodeInfo: ArrivalNodeModel) {

        switch nodeInfo.userSelected {
        case .notSelected:
//            routeNodeImageView.tintColor = .gray
//            routeLineImageView.tintColor = .gray
            break

        case .departure:
            nodeHighlightImageView.image = UIImage(named: "StartNodeImg")
            routeNodeImageView.tintColor = .blue
            routeLineImageView.tintColor = .gray

        case .middle:
            routeNodeImageView.tintColor = .blue
            routeLineImageView.tintColor = .blue
            break

        case .arrival:
            nodeHighlightImageView.image = UIImage(named: "EndNodeImg")
            routeNodeImageView.tintColor = .blue
            routeLineImageView.tintColor = .gray

        case .none:
            break
        }

        switch nodeInfo.attribute {
        case .first, .nomal, .turnaround:
            routeLineImageView.image = UIImage(named: "routeLine")
            break
        case .final:
            routeLineImageView.image = nil
            break
        case .none:
            break
        }

        routeNodeLabel.text = nodeInfo.name
    }

    func configureUI() {

        addSubview(nodeHighlightImageView)
        nodeHighlightImageView.translatesAutoresizingMaskIntoConstraints = false
        nodeHighlightImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        nodeHighlightImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true


        addSubview(routeNodeImageView)
        routeNodeImageView.translatesAutoresizingMaskIntoConstraints = false
        routeNodeImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        routeNodeImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        routeNodeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        routeNodeImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true

        addSubview(routeNodeLabel)
        routeNodeLabel.translatesAutoresizingMaskIntoConstraints = false
        routeNodeLabel.leadingAnchor.constraint(equalTo: routeNodeImageView.trailingAnchor, constant: 10).isActive = true
        routeNodeLabel.centerYAnchor.constraint(equalTo: routeNodeImageView.centerYAnchor).isActive = true

        addSubview(routeLineImageView)
        routeLineImageView.translatesAutoresizingMaskIntoConstraints = false
        routeLineImageView.topAnchor.constraint(equalTo: routeNodeImageView.bottomAnchor, constant: 10).isActive = true
        routeLineImageView.centerXAnchor.constraint(equalTo: routeNodeImageView.centerXAnchor).isActive = true
    }
}
