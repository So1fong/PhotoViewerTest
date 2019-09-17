//
//  PhotoListViewController.swift
//  PhotoViewerTest
//
//  Created by Kateryna Kozlova on 13/06/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import UIKit

var myIndex = 0
let imageCache = NSCache<NSString, UIImage>()
 
class PhotoListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, RequestDelegate
{
    func reloadData()
    {
        DispatchQueue.main.async
        {
            self.collectionView.reloadData()
        }
    }

    let cellId = "photoCell"
    let request = Request()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        request.delegate = self
        collectionView.backgroundColor = UIColor(red: 44/255, green: 57/255, blue: 95/255, alpha: 1)
        navigationItem.title = "Лента фотографий"
        navigationController?.navigationBar.barTintColor = UIColor(red: 217/255, green: 48/255, blue: 80/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("Photos.json")!
        var isDirectory: ObjCBool = false
        photoArray = []
        if FileManager.default.fileExists(atPath: jsonFilePath.absoluteString, isDirectory: &isDirectory)
        {
           loadFromFile()
        }
        if photoArray.isEmpty
        {
            request.getPhotoList(completion:
                { success in
                    if success
                    {
                        self.saveToFile()
                    }
                    else
                    {
                        self.loadFromFile()
                    }
            })
        }
    }
    
    func loadFromFile()
    {
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("Photos.json")
        print(fileUrl)
        do
        {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let tempArray = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray else
            {
                print("error?")
                return
            }
            photoArray = []
            for i in 0..<tempArray.count
            {
                let dict = tempArray[i] as! NSDictionary
                guard let id = dict["id"] as? String else { return }
                guard let small = dict["small"] as? String else { return }
                guard let full = dict["full"] as? String else { return }
                guard let date = dict["date"] as? String else { return }
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let date = formatter.date(from: date)
                {
                    photoArray.append(Photo(id: id, small: small, full: full, date: date))
                }
            }
            DispatchQueue.main.async
            {
                self.collectionView.reloadData()
            }
        }
        catch
        {
            print(error)
        }
    }
    
    func saveToFile()
    {
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("Photos.json")!
        var isDirectory: ObjCBool = false
        print(jsonFilePath)
        var jsonArr: [[String: Any]] = []
        for i in 0..<photoArray.count
        {
            jsonArr.append(["id":0])
            jsonArr[i]["id"] = photoArray[i].id
            jsonArr[i]["small"] = photoArray[i].small
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            jsonArr[i]["date"] = formatter.string(from: photoArray[i].date)
            jsonArr[i]["full"] = photoArray[i].full
        }
        do
        {
            let data = try JSONSerialization.data(withJSONObject: jsonArr, options: [])
            if !FileManager.default.fileExists(atPath: jsonFilePath.absoluteString, isDirectory: &isDirectory)
            {
                let created = FileManager.default.createFile(atPath: jsonFilePath.absoluteString, contents: data, attributes: nil)
                if created
                {
                    print("File created")
                }
                else
                {
                    print("Couldn't create file for some reason")
                }
            }
            else
            {
                print("File already exists")
                do
                {
                    let file = try FileHandle(forWritingTo: jsonFilePath)
                    file.truncateFile(atOffset: 0)
                    file.write(data)
                    print("JSON data was written to the file successfully!")
                }
                catch let error as NSError
                {
                    print("Couldn't write to file: \(error.localizedDescription)")
                }
            }
        }
        catch
        {
            print("error")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (view.frame.width / 4), height: 200)
    }
 
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoCollectionViewCell
        cell.idLabel.text = photoArray[indexPath.row].id
        guard let url = URL(string: photoArray[indexPath.row].small) else { return cell }
        request.downloadImage(url: url, completion:
        { (image, error) in
            if let image = image
            {
                DispatchQueue.main.async
                {
                    cell.photoImageView.image = image
                }
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 8, left: 3, bottom: 8, right: 3)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        myIndex = indexPath.row
        let photoVC = PhotoViewController()
        navigationController?.pushViewController(photoVC, animated: true)
    }

}
