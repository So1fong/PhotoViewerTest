//
//  PhotoViewController.swift
//  PhotoViewerTest
//
//  Created by Kateryna Kozlova on 13/06/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController
{
    let dateLabel = UILabel()
    let scrollView = UIScrollView()
    let imageView = UIImageView()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 44/255, green: 57/255, blue: 95/255, alpha: 1)
        setupDateLabel()
    }

    func setupDateLabel()
    {
        view.addSubview(dateLabel)
        dateLabel.text = "There will be date"
        dateLabel.textColor = .white
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
}
