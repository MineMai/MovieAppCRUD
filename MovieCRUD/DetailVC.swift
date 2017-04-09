//
//  DetailVC.swift
//  MovieCRUD
//
//  Created by YenShao on 2017/4/8.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var movieNameLabel: UILabel!
    
    @IBOutlet weak var movieDescribeLabel: UITextView!
    
    @IBOutlet weak var movieImage: UIImageView!
    
    
    var movieName:String?
    var movieDescribe:String?
    var moviePicture:UIImage?
    
    var detailList = [[String:String]]()
    var detailIndex:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barBtn = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editBtnFunc))
        self.navigationItem.rightBarButtonItem = barBtn
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMainList(notification:)), name: NSNotification.Name("toDetailPage"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fromEditList(notification:)), name: NSNotification.Name("fromEditPage"), object: nil)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        NotificationCenter.default.post(name: NSNotification.Name("toEditPage"), object: nil, userInfo: ["mainList":detailList,"index":detailIndex])
    }
    
    
    func getMainList(notification:Notification)
    {
        detailList = notification.userInfo?["mainList"] as! [[String:String]]
        detailIndex = notification.userInfo?["index"] as? Int
        
        guard let name = detailList[detailIndex!]["name"] else { return }
        movieNameLabel.text = name
        movieDescribeLabel.text = detailList[detailIndex!]["describe"]
        //拿圖片出來
        let imagePath = NSHomeDirectory() + "/Documents/" + "\(name).data"
        let loadedImage = UIImage(contentsOfFile: imagePath)
        movieImage.image = loadedImage
        
    }
    
    func fromEditList(notification:Notification)
    {
        detailList = notification.userInfo?["mainList"] as! [[String:String]]
        
        guard let name = detailList[detailIndex!]["name"] else { return }
        movieNameLabel.text = name
        movieDescribeLabel.text = detailList[detailIndex!]["describe"]
        //拿圖片出來
        let imagePath = NSHomeDirectory() + "/Documents/" + "\(name).data"
        let loadedImage = UIImage(contentsOfFile: imagePath)
        movieImage.image = loadedImage
    }
    

    func editBtnFunc()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyboard.instantiateViewController(withIdentifier: "EditVC") as! EditVC
        
    
        self.navigationController?.pushViewController(editVC, animated: true)
        
    }
    

    

}








