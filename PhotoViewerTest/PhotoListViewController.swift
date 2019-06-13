//
//  PhotoListViewController.swift
//  PhotoViewerTest
//
//  Created by Kateryna Kozlova on 13/06/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import UIKit

let cache = NSCache<NSString, UIImage>()
var myIndex = 0

extension UIImageView
{
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?)
    {
        self.image = nil
        if let cachedImage = cache.object(forKey: NSString(string: URLString))
        {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString)
        {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil
                {
                    print("error")
                    DispatchQueue.main.async
                    {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async
                    {
                        if let data = data
                        {
                            if let resultImage = UIImage(data: data)
                            {
                                cache.setObject(resultImage, forKey: NSString(string: URLString))
                                self.image = resultImage
                            }
                        }
                }
            }).resume()
        }
    }
}

class PhotoListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{

    let cellId = "photoCell"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(red: 44/255, green: 57/255, blue: 95/255, alpha: 1)
        navigationItem.title = "Лента фотографий"
        navigationController?.navigationBar.barTintColor = UIColor(red: 217/255, green: 48/255, blue: 80/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        Request.getPhotoList(completion: { success in
            if success
            {
                self.collectionView.reloadData()
            }
        })
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
        cell.photoImageView.imageFromServerURL(photoArray[indexPath.row].small, placeHolder: nil)
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
