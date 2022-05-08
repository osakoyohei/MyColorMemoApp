//
//  HomeViewController.swift
//  MyColorMemoApp
//
//  Created by 大迫洋平 on 2022/05/02.sw
//

import Foundation
import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var memoDataList: [MemoDataModel] = []
    let themeColorTypeKey = "themeColorTypeKey"

    override func viewDidLoad() {

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        setNavigationBarButton()
        setLeftNavigationsBarButton()
        let themeColorTypeInt = UserDefaults.standard.integer(forKey: themeColorTypeKey)
        let themeColorType = MyColorType(rawValue: themeColorTypeInt) ?? .default
        setThemeColor(type: themeColorType)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMemoData()
        tableView.reloadData()
    }

    func setMemoData() {
        let realm = try! Realm()
        let result = realm.objects(MemoDataModel.self)
        memoDataList = Array(result)
    }

    @objc func tapAddButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memoDetailViewController = storyboard.instantiateViewController(identifier: "MemoDetailViewController") as! MemoDetailViewController
        navigationController?.pushViewController(memoDetailViewController, animated: true)
    }

    func setNavigationBarButton() {
        let buttonActionSelector: Selector = #selector(tapAddButton)
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: buttonActionSelector)
        navigationItem.rightBarButtonItem = rightBarButton
    }

    func setLeftNavigationsBarButton() {
        let buttonActionSelector: Selector = #selector(didTapColorSettingButton)
        let leftButtonImage = UIImage(named: "colorSettingIcon")
        let leftButton = UIBarButtonItem(image: leftButtonImage, style: .plain, target: self, action: buttonActionSelector)
        navigationItem.leftBarButtonItem = leftButton
    }
    @objc func didTapColorSettingButton() {
        let defaultAction = UIAlertAction(title: "デフォルト", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .default)
        })
        let orangeAction = UIAlertAction(title: "オレンジ", style: .default, handler: { _ -> Void in self.setThemeColor(type: .orange)
        })
        let redAction = UIAlertAction(title: "レッド", style: .default, handler: { _ -> Void in self.setThemeColor(type: .red)
        })
        let blueAction = UIAlertAction(title: "ブルー", style: .default, handler: { _ -> Void in self.setThemeColor(type: .blue)
        })
        let pinkAction = UIAlertAction(title: "ピンク", style: .default, handler: { _ -> Void in self.setThemeColor(type: .pink)
        })
        let greenAction = UIAlertAction(title: "グリーン", style: .default, handler: { _ -> Void in self.setThemeColor(type: .green)
        })
        let purpleAction = UIAlertAction(title: "パープル", style: .default, handler: { _ -> Void in self.setThemeColor(type: .purple)
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        let alert = UIAlertController(title: "テーマカラーを選択してください", message: "", preferredStyle: .actionSheet)

        alert.addAction(defaultAction)
        alert.addAction(orangeAction)
        alert.addAction(redAction)
        alert.addAction(cancelAction)
        alert.addAction(blueAction)
        alert.addAction(pinkAction)
        alert.addAction(greenAction)
        alert.addAction(purpleAction)

        present(alert, animated: true)
    }

    func setThemeColor(type: MyColorType) {
        let isDefault = type == .default
        let tintColor: UIColor = isDefault ? .black : .white
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.barTintColor = type.color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: tintColor]
        saveThemeColor(type: type)
    }

    func saveThemeColor(type: MyColorType) {
        UserDefaults.standard.setValue(type.rawValue, forKey: themeColorTypeKey)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoDataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let memoDataModel:MemoDataModel = memoDataList[indexPath.row]
        cell.textLabel?.text = memoDataModel.text
        cell.detailTextLabel?.text = "\(memoDataModel.recordDate)"
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboad = UIStoryboard(name: "Main", bundle: nil)
        let memoDetailViewController = storyboad.instantiateViewController(identifier: "MemoDetailViewController") as! MemoDetailViewController
        let memoData = memoDataList[indexPath.row]
        memoDetailViewController.configure(memo: memoData)
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(memoDetailViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let targetMemo = memoDataList[indexPath.row]
        let realm = try! Realm()
        try! realm.write {
            realm.delete(targetMemo)
        }
        memoDataList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
