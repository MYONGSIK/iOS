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
            pin.markerType = .bluePin
            guard let latitude = resList[i].latitude else {return}
            guard let longitude = resList[i].longitude else {return}
            
            print(latitude + ", " + longitude)
            
            pin.mapPoint = MTMapPoint.init(geoCoord: .init(latitude: Double(longitude)!, longitude: Double(latitude)!))
            pin.tag = i
            
            
            mapView.add(pin)
        }
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
