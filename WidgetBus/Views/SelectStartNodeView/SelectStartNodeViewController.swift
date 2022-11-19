//
//  SelectStartNodeViewController.swift
//  WidgetBus
//
//  Created by 김민재 on 2022/11/15.
//

import UIKit

class SelectStartNodeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var selectedTableViewCellIndexPath: IndexPath?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var busNodeSearchTextField: UITextField!

    var nodeName: [String] = [
        "정류장1", "정류장2", "정류장3", "정류장4", "정류장5", "정류장6", "정류장7", "정류장8", "정류장9", "정류장10",
        "정류장11", "정류장12", "정류장13", "정류장14", "정류장15", "정류장16", "정류장17", "정류장18", "정류장19", "정류장20"
    ]
    var nodeDirection: [String] = [
        "정류장2방면", "정류장3방면", "정류장4방면", "정류장5방면", "정류장6방면",
        "정류장7방면", "정류장8방면", "정류장9방면", "정류장10방면", "정류장11방면",
        "정류장12방면", "정류장13방면", "정류장14방면", "정류장15방면", "정류장16방면",
        "정류장17방면", "정류장18방면", "정류장19방면", "정류장20방면", "정류장1방면"
    ]
    var nodeDistance: [String] = [
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
        "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // 텍스트 필드 레이아웃 설정
        busNodeSearchTextField.layer.cornerRadius = 15
        busNodeSearchTextField.layer.borderWidth = 2
        busNodeSearchTextField.layer.borderColor = UIColor.duduDeepBlue?.cgColor

        defaultTableViewSetting()
        defaultKeyboardObserverSetting()
    }

    // MARK: 테이블
    func defaultTableViewSetting() {
        self.tableView.register(
            SelectStartNodeTableViewCell.nib(),
            forCellReuseIdentifier: SelectStartNodeTableViewCell.identifier
        )

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodeName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SelectStartNodeTableViewCell.identifier,
            for: indexPath
        ) as! SelectStartNodeTableViewCell

        cell.nodeName.text = nodeName[indexPath.row]
        cell.nodeDirection.text = nodeDirection[indexPath.row]
        cell.nodeDistance.text = nodeDistance[indexPath.row]
        cell.settingData(isClicked: selectedTableViewCellIndexPath == indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedTableViewCellIndexPath == indexPath {
            selectedTableViewCellIndexPath = nil
        } else {
            if let prevSelectedTableViewCell = selectedTableViewCellIndexPath {
                selectedTableViewCellIndexPath = indexPath
                tableView.reloadRows(at: [prevSelectedTableViewCell], with: .automatic)
            } else {
                selectedTableViewCellIndexPath = indexPath
            }
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    // MARK: 키보드
    func defaultKeyboardObserverSetting() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }

    @IBAction func didEndOnExit(_ sender: Any) {
        // 키보드 완료 버튼 눌렀을 때 busNodeSearchTextField.text를 이용해 API 호출
        print(busNodeSearchTextField.text ?? "텍스트 필드 입력값 없음")
    }

    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame: NSValue =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 1) {
                self.view.frame.origin.y -= keyboardHeight
            }
        }
    }

    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
}
