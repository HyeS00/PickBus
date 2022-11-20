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

    // 도시코드 딕션어리
    private var cityCodeDictionary = [Int: String]()

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
        busNodeSearchTextField.addLeftPadding()

        // 도시 코드 가져오기
        getCityCode()

        defaultTableViewSetting()
        defaultKeyboardObserverSetting()
    }

    func getCityCode(isInit: Bool = true) {
        if isInit {
            BusClient.getCityCodeList(completion: handleRequestCityCodeResponse(response:error:))
        } else {
            BusClient.getCityCodeList(completion: handleRequestCityCodeResponseSearch(response:error:))
        }
    }

    // MARK: 테이블
    func defaultTableViewSetting() {
        tableView.register(
            SelectStartNodeTableViewCell.nib(),
            forCellReuseIdentifier: SelectStartNodeTableViewCell.identifier
        )

        tableView.delegate = self
        tableView.dataSource = self
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
        if cityCodeDictionary.isEmpty {
            getCityCode(isInit: false)
        } else {

            let nodeNm: String?
            let nodeNo: String?
            // 번호 검색인지 이름 검색인지 확인.
            if Int(self.busNodeSearchTextField.text ?? "") == nil {
                nodeNo = nil
                nodeNm = self.busNodeSearchTextField.text ?? ""
            } else {
                nodeNo = self.busNodeSearchTextField.text ?? ""
                nodeNm = nil
            }

            DispatchQueue.global(qos: .userInitiated).async {
                var count = 1

                for mCityCode in self.cityCodeDictionary.keys {
//                    print(mCityCode)
                    count += 1
                    BusClient.searchNodeList(
                        city: String(mCityCode),
                        nodeNm: nodeNm,
                        nodeNo: nodeNo,
                        completion: self.handleRequestSearchNodeResponse(cityCode:response:error:))
                    if count % 29 == 0 {
                        sleep(1)
                    }
                }
            }
        }
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

    // 도시 코드 가져오는 네트워크 완료된 다음 실행되는 콜백(초반)
    func handleRequestCityCodeResponse(response: [CityCodeInfo], error: Error?) {
        guard error == nil else {
            //            print(error?.localizedDescription)
            return
        }
        if !response.isEmpty {
            cityCodeDictionary = makeCityCodeDictionary(cityCodeArray: response)
            //            print(cityCodeDictionary)
        }
    }

    // 도시 코드 가져오는 네트워크 완료된 다음 실행되는 콜백(검색)
    func handleRequestCityCodeResponseSearch(response: [CityCodeInfo], error: Error?) {
        guard error == nil else {
            //            print(error?.localizedDescription)
            return
        }
        if !response.isEmpty {
            cityCodeDictionary = makeCityCodeDictionary(cityCodeArray: response)
            BusClient.searchNodeList(completion: handleRequestSearchNodeResponse(cityCode:response:error:))
            //            print(cityCodeDictionary)
        }
    }

    // 검색 후, 실행되는 콜백
    func handleRequestSearchNodeResponse(cityCode: Int?, response: [SearchNodeInfo], error: Error?) {
        guard error == nil else {
//            print(error?.localizedDescription)
            return
        }

        // 로빈 여기서 필요한 항목들 뽑아서 사용하면 될 듯 합니다.
        if !response.isEmpty {
            print(cityCode!)
            print(cityCodeDictionary[cityCode!] ?? "Nil_")
            print(response)
        }
    }

    // 배열을 딕션어리로 변경하는 함수
    func makeCityCodeDictionary(cityCodeArray: [CityCodeInfo]) -> [Int: String] {
        var tmpCityCodeDictionary = [Int: String]()
        for cityCode in cityCodeArray {
            if tmpCityCodeDictionary.keys.contains(cityCode.citycode) {
                continue
            } else {
                tmpCityCodeDictionary[cityCode.citycode] = cityCode.cityname
            }
        }
        return tmpCityCodeDictionary
    }
}
