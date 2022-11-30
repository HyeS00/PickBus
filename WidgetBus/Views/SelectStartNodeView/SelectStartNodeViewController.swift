//
//  SelectStartNodeViewController.swift
//  WidgetBus
//
//  Created by 김민재 on 2022/11/15.
//

import UIKit
import CoreLocation

struct TmpStruct {
    /// cityCode
    var cityCode: String
    /// 정류장 ID
    var nodeid: String
    /// 정류장 이름
    var nodenm: String
    /// 정류장 번호
    var nodeno: Int
}

final class SelectStartNodeViewController:
    BackgroundViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var startBusNodeTableView: UITableView!
    @IBOutlet private weak var busNodeSearchTextField: UITextField!

    // CoreData Controller
    var dataController: DataController!
    var newGroup: Group!
    var temp = TmpStruct(cityCode: "", nodeid: "", nodenm: "", nodeno: -1)

    @IBAction private func didKeyboardEndOnExit(_ sender: Any) {
        // 키보드 완료 버튼 눌렀을 때 busNodeSearchTextField.text를 이용해 API 호출
        workItem?.cancel()
        if cityCodeDictionary.isEmpty {
            getCityCode(isInit: false)
        } else {
            startSearch()
        }
    }

    @IBAction private func editingTextFieldChanged(_ sender: Any) {
        stop = true
        if repeatCount == cityCodeDictionary.keys.count {
            clearNetworkSessionTask()
        }
    }

    private var selectedTableViewCellIndexPath: IndexPath?

    // load task
    private var loadTasks = [URLSessionDataTask]()
    // work item
    private var workItem: DispatchWorkItem?
    private var stop: Bool = false
    private var repeatCount: Int = 1

    // 도시코드 딕션어리
    private var cityCodeDictionary = [Int: String]()

    private var nodeList = [StartNodeModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setTitleAndIndicator(titleText: "출발 정류장을\n선택해 주세요", indicatorStep: .stepTwo)

        contentView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        // 텍스트 필드 레이아웃 설정
        busNodeSearchTextField.layer.cornerRadius = 15
        busNodeSearchTextField.layer.borderWidth = 2
        busNodeSearchTextField.layer.borderColor = UIColor.duduDeepBlue?.cgColor
        busNodeSearchTextField.addLeftPadding()

        let rightButton = UIBarButtonItem(
            title: "다음",
            style: .plain,
            target: self,
            action: #selector(pressButton(_:))
        )
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.tintColor = .white

        // 도시 코드 가져오기
        getCityCode()

        settingDefaultTableView()
        addDefaultKeyboardObserver()
    }

    @objc func pressButton(_ sender: UIBarButtonItem) {

        let storyboard = UIStoryboard(name: "RouteNumberViewStoryboard", bundle: nil)
        let selectRouteNodeViewController =
        storyboard.instantiateViewController(
            withIdentifier: "SelectRouteNumberViewController") as! SelectRouteNumberViewController

        let newNode = Node(context: dataController.viewContext)
        newNode.cityCode = temp.cityCode
        newNode.nodeId = temp.nodeid
        newNode.nodeNm = temp.nodenm
        newNode.nodeNo = String(temp.nodeno)

        selectRouteNodeViewController.dataController = dataController
        selectRouteNodeViewController.newGroup = newGroup
        selectRouteNodeViewController.newNode = newNode

        self.navigationController?.pushViewController(selectRouteNodeViewController, animated: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        removeDefaultKeyboardObserver()
    }

    func getCityCode(isInit: Bool = true) {
        if isInit {
            BusClient.getCityCodeList(completion: handleRequestCityCodeResponse(response:error:))
        } else {
            BusClient.getCityCodeList(completion: handleRequestCityCodeResponseSearch(response:error:))
        }
    }

    // MARK: 테이블
    func settingDefaultTableView() {
        startBusNodeTableView.register(
            SelectStartNodeTableViewCell.nib(),
            forCellReuseIdentifier: SelectStartNodeTableViewCell.identifier
        )
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SelectStartNodeTableViewCell.identifier,
            for: indexPath
        ) as? SelectStartNodeTableViewCell else {
            return UITableViewCell()
        }

        cell.nodeName.text = nodeList[indexPath.row].nodeName
        cell.nodeDirection.text = "방향 추가 예정"
        cell.nodeDistance.text = "거리 추가 예정"
        cell.nodeCoordinate = nodeList[indexPath.row].nodeCLLocationCoordinate2D
        cell.settingData(isClicked: selectedTableViewCellIndexPath == indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedTableViewCellIndexPath == indexPath {
            selectedTableViewCellIndexPath = nil
        } else {
            // selectedTableViewCellIndexPath가 prevSelectedTableViewCell로 이동된 후 실행되어야 함
            if let prevSelectedTableViewCell = selectedTableViewCellIndexPath {
                selectedTableViewCellIndexPath = indexPath
                tableView.reloadRows(at: [prevSelectedTableViewCell], with: .automatic)
            } else {
                selectedTableViewCellIndexPath = indexPath
            }
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)

        // 셀이 선택되어 있을 때 네비게이션 바의 다음 버튼 활성화
        navigationItem.rightBarButtonItem?.isEnabled = selectedTableViewCellIndexPath != nil
    }

    // MARK: 키보드
    private func addDefaultKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
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

    private func removeDefaultKeyboardObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame: NSValue =
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        UIView.animate(withDuration: 1) {
            self.view.frame.origin.y -= keyboardHeight
        }
    }

    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nodeList.removeAll()
        selectedTableViewCellIndexPath = nil
        startBusNodeTableView.reloadData()
        return true
    }

    // MARK: 검색

    // 검색 시작
    func startSearch() {
        let nodeName: String?
        let nodeNumber: String?
        // 번호 검색인지 이름 검색인지 확인.
        if Int(self.busNodeSearchTextField.text ?? "") == nil {
            nodeNumber = nil
            nodeName = self.busNodeSearchTextField.text ?? ""
        } else {
            nodeNumber = self.busNodeSearchTextField.text ?? ""
            nodeName = nil
        }

        workItem = DispatchWorkItem {
            self.repeatCount = 0
            self.loadTasks = [URLSessionDataTask]()

            for mCityCode in self.cityCodeDictionary.keys {

                if self.stop {
                    self.clearNetworkSessionTask()
                    break
                }
                self.repeatCount += 1
                let task = BusClient.searchNodeList(
                    city: String(mCityCode),
                    nodeName: nodeName,
                    nodeNumber: nodeNumber,
                    completion: self.handleRequestSearchNodeResponse(cityCode:response:error:))

                self.loadTasks.append(task)

                if self.repeatCount % 25 == 0 && self.repeatCount > 0 {
                    sleep(1)
                }
            }
        }
        if let workItem = workItem {
            stop = false
            DispatchQueue.global(qos: .userInitiated).async(execute: workItem)

        }
    }

    // 도시 코드 가져오는 네트워크 완료된 다음 실행되는 콜백(초반)
    func handleRequestCityCodeResponse(response: [CityCodeInfo], error: Error?) {
        guard error == nil else {
            return
        }
        if !response.isEmpty {
            cityCodeDictionary = makeCityCodeDictionary(cityCodeArray: response)
        }
    }

    // 도시 코드 가져오는 네트워크 완료된 다음 실행되는 콜백(검색)
    func handleRequestCityCodeResponseSearch(response: [CityCodeInfo], error: Error?) {
        guard error == nil else {
            return
        }
        if !response.isEmpty {
            cityCodeDictionary = makeCityCodeDictionary(cityCodeArray: response)
            startSearch()
        }
    }

    // 검색 후, 실행되는 콜백
    func handleRequestSearchNodeResponse(cityCode: Int?, response: [SearchNodeInfo], error: Error?) {
        guard error == nil else {
            return
        }

        // API 응답 결과
        if !response.isEmpty {
            temp.cityCode = String(cityCode ?? -1)
            temp.nodeno = response[0].nodeno
            temp.nodeid = response[0].nodeid
            temp.nodenm = response[0].nodenm

            startBusNodeTableView.beginUpdates()
            response.forEach {
                nodeList.append(
                    StartNodeModel(
                        nodeName: $0.nodenm,
                        nodeID: $0.nodeid,
                        nodeCityCode: cityCode ?? -1,
                        nodeCityName: cityCodeDictionary[cityCode ?? -1] ?? "Nil_"
                        ,
                        nodeCLLocationCoordinate2D: CLLocationCoordinate2D(
                            latitude: Double($0.gpslati.stringValue) ?? -1,
                            longitude: Double($0.gpslong.stringValue) ?? -1
                        )
                    )
                )

                startBusNodeTableView.insertRows(at: [IndexPath(row: nodeList.count - 1, section: 0)], with: .automatic)
            }
            startBusNodeTableView.endUpdates()

        }
    }

    // 네트워크 작동 취소
    func clearNetworkSessionTask() {
        for loadTask in self.loadTasks {
            if loadTask.state == .running || loadTask.state == .suspended {
                loadTask.cancel()
            }

        }
        self.loadTasks = [URLSessionDataTask]()
        repeatCount = 0
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
