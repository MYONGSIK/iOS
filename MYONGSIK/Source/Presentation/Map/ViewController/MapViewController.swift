//
//  MapViewController.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/04/14.
//

import UIKit
import Alamofire

class MapViewController: UIViewController {
    
    var mapView: MTMapView!
    
    private var campusInfo: CampusInfo = .seoul
    private var resList: [StoreModel] = []
    private var pinList: [MTMapPOIItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setCampusInfo()
        fetchResData()
        setup()
        
    }
    
    private func setup() {
        mapView = MTMapView(frame: self.view.frame)
        mapView.setMapCenter(.init(geoCoord: .init(latitude: 37.5799602085862, longitude: 126.92324331937944)), animated: true)
        mapView.delegate = self
        mapView.baseMapType = .standard
        setupPin()
        self.view.addSubview(mapView)
    }
    
    private func setupPin() {
        for i in 0..<resList.count {
            let pin = MTMapPOIItem()
            pin.markerType = .customImage
            pin.markerSelectedType = .customImage
            pin.customImage = pinImage(text: resList[i].scrapCount!.description)
            pin.customSelectedImage = selectedPinImage(text: resList[i].scrapCount!.description)
            guard let latitude = resList[i].latitude else {return}
            guard let longitude = resList[i].longitude else {return}
            
            print(latitude + ", " + longitude)
            
            pin.mapPoint = MTMapPoint.init(geoCoord: .init(latitude: Double(longitude)!, longitude: Double(latitude)!))
            pin.tag = i
            
            
            mapView.add(pin)
        }
    }
    
    func imageResize(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
           let size = CGSize(width: newWidth, height: newHeight)
           let render = UIGraphicsImageRenderer(size: size)
           let renderImage = render.image { context in
               image.draw(in: CGRect(origin: .zero, size: size))
           }
           
           return renderImage
       }
    
    
    func pinImage(text: String) -> UIImage? {
        let image = imageResize(image: UIImage(named: "mapPin")!, newWidth: 65, newHeight: 80)
        let imageSize = image.size
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageSize.width, height: imageSize.height), false, 1.0)
        let currentView = UIView(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let currentImage = UIImageView(image: image)
        currentImage.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        currentView.addSubview(currentImage)

        let label = UILabel()
        label.frame = currentView.frame
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 35)
        label.textColor = .white
        label.text = text
        label.center = currentView.center
        currentView.addSubview(label)

        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        currentView.layer.render(in: currentContext)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    func selectedPinImage(text: String) -> UIImage? {
        let image = imageResize(image: UIImage(named: "selectedMapPin")!, newWidth: 130, newHeight: 150)
        let imageSize = image.size
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageSize.width, height: imageSize.height), false, 1.0)
        let currentView = UIView(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let currentImage = UIImageView(image: image)
        currentImage.frame = CGRect(x: -15, y: 0, width: imageSize.width, height: imageSize.height)
        currentView.addSubview(currentImage)

        let label = UILabel()
        currentView.addSubview(label)
        label.frame = CGRect(x: -15, y: 0, width: currentView.frame.width, height: currentView.frame.height-30)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = .black
        label.text = text
        

        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        currentView.layer.render(in: currentContext)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    
    
    
    func setCampusInfo() {
        if let userCampus  = UserDefaults.standard.value(forKey: "userCampus") {
            switch userCampus as! String {
            case CampusInfo.seoul.name:
                campusInfo = .seoul
            case CampusInfo.yongin.name:
                campusInfo = .yongin
            default:
                return
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}


extension MapViewController: MTMapViewDelegate {
    
}


extension MapViewController {
    func fetchResData() {
        
        let queryParam: Parameters = [
            "sort": "scrapCount,desc",
            "campus" : (campusInfo == .seoul) ? "SEOUL" : "YONGIN",
            "size": Int32.max
        ]
        
        APIManager.shared.getData(urlEndpointString: Constants.getStoreRank,
                                  dataType: StoreRankModel.self,
                                  parameter: queryParam,
                                  completionHandler: { [weak self] response in
            if response.success {
                self?.resList = response.data.content
                self?.setupPin()
            } else {
                self?.showAlert(message: "맛집 지도 정보를 가져올 수 없습니다.")
            }
        })
    }
}
