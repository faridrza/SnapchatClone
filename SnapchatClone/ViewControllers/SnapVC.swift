//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Farid Rzayev on 21.01.22.
//

import UIKit
import ImageSlideshow


class SnapVC: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    var time : Int?
    var snaps : Snap?
    var imageurlArray = [SDWebImageSource]()
    var updatedTime : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let timeLeft = snaps?.updatedTime {
            self.timeLabel.text = "\(timeLeft) hours left"
            if let snap = self.snaps {
                for urls in snap.feedUrlArray {
                    imageurlArray.append(SDWebImageSource(urlString: urls)!)
                    }
            }
            
        }
        
        let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10 , y: 25, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
        imageSlideShow.backgroundColor = UIColor.white
        imageSlideShow.setImageInputs(imageurlArray)
        imageSlideShow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        imageSlideShow.pageControl.pageIndicatorTintColor = UIColor.black
        
        self.view.addSubview(imageSlideShow)
        self.view.bringSubviewToFront(timeLabel)
        // Do any additional setup after loading the view.
    }
    

    

}
