//
//  ViewController.swift
//  ios
//
//  Created by 柳沼匠 on 2016/06/17.
//  Copyright © 2016年 柳沼匠. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // 2. StoryBoardとつなぐ
    @IBOutlet weak var tableView: UITableView!
    
    // 5. テーブルに表示するテキスト
    var texts:[String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 4. delegateとdataSourceを設定
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 6. 必要なtableViewメソッド
    // セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    // 6. 必要なtableViewメソッド
    // セルのテキストを追加
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = texts[indexPath.row]
        return cell
    }
    
    // 7. セルがタップされた時
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        print(texts[indexPath.row])
    }
    
    @IBAction func touchButton(sender: AnyObject) {
        print("fuga")
        
        // アイテムを追加
        texts.append("hoge")
        
        // TableView読み込み
        tableView.reloadData()
    }
}
