//
//  Request.swift
//  PhotoViewerTest
//
//  Created by Kateryna Kozlova on 13/06/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import Foundation
import UIKit

struct Photo
{
    var id = ""
    var small = ""
    var full = ""
    var date = Date()
}

protocol RequestDelegate
{
    func reloadData()
}

var photoArray: [Photo] = [Photo()]

class Request
{
    var delegate: RequestDelegate?
    
    func getPhotoList(completion: @escaping (_ success: Bool) -> ())
    {
        let per_page = 30
        let order_by = "popular"
        let token = "5c751ca303013d445adb2daaff6af72189d532cefc25a25c79bed4e42ab82212"
        let stringURL = "https://api.unsplash.com/photos"
        guard let url = URL(string: stringURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("\(per_page)", forHTTPHeaderField: "per_page")
        request.setValue("\(order_by)", forHTTPHeaderField: "order_by")
        request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error as? URLError, error.code == URLError.Code.notConnectedToInternet
            {
                completion(false)
            }
            guard let data = data else { return }
            if let response = response as? HTTPURLResponse
            {
                switch response.statusCode
                {
                case 200..<300:
                    print("success")
                    do
                    {
                        let json = try JSONSerialization.jsonObject(with: data, options: .init())
                        let answerArray = json as! NSArray
                        photoArray = []
                        for i in 0..<answerArray.count
                        {
                            photoArray.append(Photo())
                            let photo = answerArray.object(at: i) as! NSDictionary
                            photoArray[i].id = photo.value(forKey: "id") as! String
                            let urls = photo.value(forKey: "urls") as! NSDictionary
                            photoArray[i].small = urls.value(forKey: "small") as! String
                            photoArray[i].full = urls.value(forKey: "full") as! String
                            photoArray[i].date = Date()
                        }
                        completion(true)
                        self.delegate?.reloadData()
                    }
                        catch let error
                    {
                        print("\(error.localizedDescription)")
                        completion(false)
                    }
                default:
                    print("status: \(response.statusCode)")
                    completion(false)
                }
            }
        }).resume()
    }
    
    func downloadImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void)
    {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString)
        {
            completion(cachedImage, nil)
        }
        else
        {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error
                {
                    completion(nil, error)
                }
                else if let data = data, let image = UIImage(data: data)
                {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image, nil)
                }
                else
                {
                    let error = NSError()
                    completion(nil, error)
                }
            }).resume()
        }
    }
}
