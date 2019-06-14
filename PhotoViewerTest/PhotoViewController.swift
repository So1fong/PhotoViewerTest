//
//  PhotoViewController.swift
//  PhotoViewerTest
//
//  Created by Kateryna Kozlova on 13/06/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate
{
    let dateLabel = UILabel()
    let scrollView = UIScrollView()
    let imageView = UIImageView()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        scrollView.delegate = self
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = UIColor(red: 44/255, green: 57/255, blue: 95/255, alpha: 1)
        setupDateLabel()
        setupScrollView()
        setupImageView()
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
    
    func setupScrollView()
    {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.maximumZoomScale = 1.0
        scrollView.minimumZoomScale = 0.1
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.backgroundColor = UIColor(red: 44/255, green: 57/255, blue: 95/255, alpha: 1)
    }
    
    func setupImageView()
    {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        imageView.imageFromServerURL(photoArray[myIndex].full, placeHolder: nil)
        guard let image = imageView.image else { return }
        scrollView.contentSize = image.size
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
