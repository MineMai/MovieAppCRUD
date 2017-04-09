//
//  MainTBVC.swift
//  MovieCRUD
//
//  Created by YenShao on 2017/4/8.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit

class MainTBVC: UITableViewController {
    
    //指定路徑
    let path = NSHomeDirectory() + "/Documents" + "/movieData.txt"
    
    var movieList = [[String:String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addBtn = UIBarButtonItem(title: "➕", style: .plain, target: self, action: #selector(addBtnFunc))
        
        navigationItem.rightBarButtonItem = addBtn
        
        NotificationCenter.default.addObserver(self, selector: #selector(fromEditList(notification:)), name: NSNotification.Name("fromEditPage"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        movieList = []
        //從資料夾拿出Array
        if let loadedArray = NSArray(contentsOfFile: path) as? [[String:String]]
        {
            for i in 0..<loadedArray.count
            {
                movieList.append(loadedArray[i])
            }
            
            tableView.reloadData()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //因為接收端在下一頁，所以如果這裡先發送，下一頁還沒生出來也收不到
        //不過如果發送端寫在didDisappear裡，下一頁就收的到了
        NotificationCenter.default.post(name: NSNotification.Name("forAddPage"), object: nil, userInfo: ["mainList":movieList])
        
        if let indexPath = tableView.indexPathForSelectedRow?.row
        {
            NotificationCenter.default.post(name: NSNotification.Name("toDetailPage"), object: nil, userInfo: ["mainList":movieList,"index":indexPath])
            
        }
        
    }
    
    func addBtnFunc()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addVC = storyboard.instantiateViewController(withIdentifier: "AddVC") as! AddVC
        
        navigationController?.pushViewController(addVC, animated: true)
        
    }

    

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movieList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = movieList[indexPath.row]["name"]

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        detailVC.detailIndex = indexPath.row
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            print("index = \(indexPath.row)")
            print("List = \(movieList.count)")
            
            movieList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
            let arrayToSave = movieList as NSArray
            arrayToSave.write(toFile: self.path, atomically: true)
        }
    }
    
    
    
    
    func fromEditList(notification:Notification)
    {
        movieList = notification.userInfo?["mainList"] as! [[String:String]]
        
        tableView.reloadData()

    }
    
    
    
    

    

}














