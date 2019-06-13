//
//  Request.swift
//  PhotoViewerTest
//
//  Created by Kateryna Kozlova on 13/06/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import Foundation
import Alamofire

struct Photo
{
    var id = ""
    var small = ""
    var full = ""
    var date = Date()
}

var photoArray: [Photo] = [Photo()]

class Request
{
    static func getPhotoList(completion: @escaping (_ success: Bool) -> ())
    {
        var result: Bool?
        let count = 30
        let token = "5c751ca303013d445adb2daaff6af72189d532cefc25a25c79bed4e42ab82212"
        AF.request("https://api.unsplash.com/photos/random?count=\(count)&client_id=\(token)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler:
            { response in
                switch response.result
                {
                case .success(let JSON):
                    let answerArray = JSON as! NSArray
                    //print(answerArray)
                    photoArray = []
                    for i in 0..<answerArray.count
                    {
                        photoArray.append(Photo())
                        let photo = answerArray.object(at: i) as! NSDictionary
                        photoArray[i].id = photo.value(forKey: "id") as! String
                        let urls = photo.value(forKey: "urls") as! NSDictionary
                        photoArray[i].small = urls.value(forKey: "small") as! String
                        photoArray[i].full = urls.value(forKey: "full") as! String
                    }
                    print(photoArray)
                    result = true
                case .failure(let error):
                    print(error)
                    result = false
                }
                completion(result!)
        })
    }
    
}
