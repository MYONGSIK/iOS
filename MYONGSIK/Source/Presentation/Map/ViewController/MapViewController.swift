//
//  MapViewController.swift
//  MYONGSIK
//
//  Created by 유상 on 3/2/24.
//

import UIKit
import KakaoMapsSDK

class MapViewController: UIViewController {
    
    private var mapController: KMController?
    private var mapContainer: KMViewContainer?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapContainer = self.view as? KMViewContainer
        mapController = KMController(viewContainer: mapContainer!)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
