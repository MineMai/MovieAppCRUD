//
//  AddVC.swift
//  MovieCRUD
//
//  Created by YenShao on 2017/4/8.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit

class AddVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var addName: UITextField!
    
    @IBOutlet weak var addDescribe: UITextView!
    
    @IBOutlet weak var addImage: UIImageView!
    
    @IBOutlet weak var uiview: UIView!
    
    var movieArray = [[String:String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveBtnFunc))
        navigationItem.rightBarButtonItem = saveBtn
        
        addImage.contentMode = .scaleAspectFill
        
        //在圖片上加入點擊手勢效果
        uiview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfileImage)))
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMainList(notification:)), name: NSNotification.Name("forAddPage"), object: nil)

        
    }
    
    func getMainList(notification: Notification)
    {
        let getmainlist = notification.userInfo!["mainList"] as! [[String:String]]
        movieArray = getmainlist
    }
    
    
    func saveBtnFunc()
    {
        if checkempty()
        {
            //----存文字檔----
            let movieDict:[String:String] = ["name":addName.text!,"describe":addDescribe.text!]
            
            movieArray.append(movieDict)
            
            //因為要存到手機裡，要轉成NSArray
            let arrayToSave = NSArray(array: movieArray)
            
            //指定路徑
            let path = NSHomeDirectory() + "/Documents" + "/movieData.txt"
            
            arrayToSave.write(toFile: path, atomically: true)
            
            //存圖片，要存的是Data型別
            let imagePath = NSHomeDirectory() + "/Documents/" + "\(addName.text!).data" //這是存檔路徑
            let url = URL(fileURLWithPath: imagePath) //路徑轉URL
            //把圖片轉成Data
            let imageToSave = UIImageJPEGRepresentation(addImage.image!, 1.0)
            do
            {
                try imageToSave?.write(to: url) //存入暫存資料夾
            }
            catch
            {
                print(error)
            }
            
            //回前一頁
            let _ = navigationController?.popViewController(animated: true)
        }
        else
        {
            return
        }
    }
    
    
    func selectProfileImage()
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        show(imagePickerController, sender: self)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        addImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: nil)
        
    }

    
    func checkempty() -> Bool
    {
        if addName.text != "" && addDescribe.text != "" && addImage.image != nil
        {
            return true
        }
        else
        {
            alertTheUser(title: "尚未完成欄位", message: "請輸入資料")
            return false
        }
    }
    
    func alertTheUser(title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    

}



















