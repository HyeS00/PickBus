//
//  ArrivalTableViewCell.swift
//  WidgetBus
//
//  Created by LeeJaehoon on 2022/11/14.
//

import UIKit

class ArrivalTableViewCell: UITableViewCell {
    // MARK: - Properties
    private let highlightView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 303, height: 46)
        view.layer.cornerRadius = 15
        return view
    }()

    private let highlightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    private let routeNodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down.circle")
        imageView.tintColor = UIColor.duduGray
        return imageView
    }()

    private let routeNodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19)
        return label
    }()

    private let testLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19)
        return label
    }()

    private let routeLineView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 3, height: 36)
        view.layer.backgroundColor = UIColor.gray.cgColor
        return view
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

        routeNodeImageView.tintColor = UIColor.duduGray
        routeLineView.backgroundColor = UIColor.duduGray

        highlightView.backgroundColor = .none
        highlightLabel.text = .none

    }

    // MARK: - Helpers
    public func configure(nodeInfo: ArrivalNodeModel) {

        switch nodeInfo.userSelected {
        case .depart(.notOnlyDep):
            routeLineView.backgroundColor = UIColor.duduDeepBlue
            fallthrough
        case .depart(.onlyDep):
            highlightView.backgroundColor = UIColor.duduRed
            highlightLabel.text = "출발"
            routeNodeImageView.tintColor = UIColor.duduDeepBlue
        case .middle:
            routeNodeImageView.tintColor = UIColor.duduDeepBlue
            routeLineView.backgroundColor = UIColor.duduDeepBlue
        case .arrival:
            highlightView.backgroundColor = UIColor.duduBlue
            highlightLabel.text = "도착"
            routeNodeImageView.tintColor = UIColor.duduDeepBlue
        default:
            break
        }

        switch nodeInfo.attribute {
        case .first:
            testLabel.text = "기점"
        case .nomal:
            testLabel.text = "일반"
        case .turnaround:
            testLabel.text = "회차지"
        case .final:
            routeLineView.backgroundColor = .none
            testLabel.text = "종점"
        default:
            break
        }

        routeNodeLabel.text = nodeInfo.name
    }

    func configureUI() {

        addSubview(highlightView)
        highlightView.translatesAutoresizingMaskIntoConstraints = false
        highlightView.widthAnchor.constraint(equalToConstant: highlightView.frame.width).isActive = true
        highlightView.heightAnchor.constraint(equalToConstant: highlightView.frame.height).isActive = true
        highlightView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        addSubview(highlightLabel)
        highlightLabel.translatesAutoresizingMaskIntoConstraints = false
        highlightLabel.centerYAnchor.constraint(equalTo: highlightView.centerYAnchor).isActive = true
        highlightLabel.trailingAnchor.constraint(equalTo: highlightView.trailingAnchor, constant: -7)
            .isActive = true

        addSubview(routeNodeImageView)
        routeNodeImageView.translatesAutoresizingMaskIntoConstraints = false
        routeNodeImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        routeNodeImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        routeNodeImageView.centerYAnchor.constraint(equalTo: highlightView.centerYAnchor).isActive = true
        routeNodeImageView.leadingAnchor.constraint(equalTo: highlightView.leadingAnchor, constant: 18)
            .isActive = true

        addSubview(routeNodeLabel)
        routeNodeLabel.translatesAutoresizingMaskIntoConstraints = false
        routeNodeLabel.leadingAnchor.constraint(equalTo: routeNodeImageView.trailingAnchor, constant: 14)
            .isActive = true
        routeNodeLabel.centerYAnchor.constraint(equalTo: routeNodeImageView.centerYAnchor).isActive = true

        addSubview(routeLineView)
        routeLineView.translatesAutoresizingMaskIntoConstraints = false
        routeLineView.widthAnchor.constraint(equalToConstant: routeLineView.frame.width).isActive = true
        routeLineView.heightAnchor.constraint(equalToConstant: routeLineView.frame.height).isActive = true
        routeLineView.centerXAnchor.constraint(equalTo: routeNodeImageView.centerXAnchor).isActive = true
        routeLineView.topAnchor.constraint(equalTo: routeNodeImageView.bottomAnchor, constant: 4)
            .isActive = true
    }
}
