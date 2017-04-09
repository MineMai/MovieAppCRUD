//
//  EditVC.swift
//  MovieCRUD
//
//  Created by YenShao on 2017/4/8.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit

class EditVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var editName: UITextField!
    
    @IBOutlet weak var editDescribe: UITextView!
    
    @IBOutlet weak var editImage: UIImageView!
    
    @IBOutlet weak var editUIView: UIView!
    
    var editMovieName:String?
    var editMovieDescribe:String?
    var editMoviePicture:UIImage?
    var editIndex:Int?
    
    var editList = [[String:String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtnFunc))
        navigationItem.rightBarButtonItem = doneBtn
        
        //在圖片上加入點擊手勢效果
        editUIView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfileImage)))
        
        editName.text = editMovieName
        editDescribe.text = editMovieDescribe
        editImage.image = editMoviePicture
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMainList(notification:)), name: NSNotification.Name("toEditPage"), object: nil)
        
    }
    
    
    func getMainList(notification:Notification)
    {
        editList = notification.userInfo?["mainList"] as! [[String:String]]
        editIndex = notification.userInfo?["index"] as? Int
        
        guard let name = editList[editIndex!]["name"] else { return }
        editName.text = name
        editDescribe.text = editList[editIndex!]["describe"]
        //拿圖片出來
        let imagePath = NSHomeDirectory() + "/Documents/" + "\(name).data"
        let loadedImage = UIImage(contentsOfFile: imagePath)
        editImage.image = loadedImage
    }
    
    
    func doneBtnFunc()
    {
        print("Done被按下了")
        
        if checkempty()
        {
            //----存文字檔----
            let movieDict:[String:String] = ["name":editName.text!,"describe":editDescribe.text!]
            
            editList[editIndex!] = movieDict
            
            //因為要存到手機裡，要轉成NSArray
            let arrayToSave = NSArray(array: editList)
            
            //指定路徑
            let path = NSHomeDirectory() + "/Documents" + "/movieData.txt"
            
            arrayToSave.write(toFile: path, atomically: true)
            
            //存圖片，要存的是Data型別
            let imagePath = NSHomeDirectory() + "/Documents/" + "\(editName.text!).data" //這是存檔路徑
            let url = URL(fileURLWithPath: imagePath) //路徑轉URL
            //把圖片轉成Data
            let imageToSave = UIImageJPEGRepresentation(editImage.image!, 1.0)
            do
            {
                try imageToSave?.write(to: url) //存入暫存資料夾
            }
            catch {
                print(error)
            }
            
            NotificationCenter.default.post(name: NSNotification.Name("fromEditPage"), object: nil, userInfo: ["mainList":editList])
            
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
        
        editImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func checkempty() -> Bool
    {
        if editName.text != "" && editDescribe.text != "" && editImage.image != nil
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


















