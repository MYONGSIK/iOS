//
//  MapViewController.swift
//  MYONGSIK
//
//  Created by 유상 on 3/2/24.
//

import UIKit
import KakaoMapsSDK
import Toast
import Combine

class MapViewController: UIViewController, MapControllerDelegate {
    private var viewModel = MapViewModel()
    private var cancellabels = Set<AnyCancellable>()
    private let input: PassthroughSubject<MapViewModel.Input, Never> = .init()
    
    private var mapInfoView: UIView!
    
    private var mapController: KMController?
    private var mapContainer: KMViewContainer?
    private var _observerAdded: Bool = false
    private var _auth: Bool = false
    private var _appear: Bool = false
    private var restaurantList: [RestaurantModel] = []
    private var selectId: Int?
    
    deinit {
        mapController?.stopRendering()
        mapController?.stopEngine()
        
        print("deinit")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = KMViewContainer()
        mapContainer = self.view as? KMViewContainer
       
        //KMController 생성.
        mapController = KMController(viewContainer: mapContainer!)
        mapController!.delegate = self
       
        mapController?.initEngine()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObservers()
        _appear = true
        if mapController?.engineStarted == false {
            mapController?.startEngine()
        }
        
        if mapController?.rendering == false {
            mapController?.startRendering()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        _appear = false
        mapController?.stopRendering()  //렌더링 중지.
    }

    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
        mapController?.stopEngine()     //엔진 정지. 추가되었던 ViewBase들이 삭제된다.
    }
    
    func authenticationSucceeded() {
        // 일반적으로 내부적으로 인증과정 진행하여 성공한 경우 별도의 작업은 필요하지 않으나,
        // 네트워크 실패와 같은 이슈로 인증실패하여 인증을 재시도한 경우, 성공한 후 정지된 엔진을 다시 시작할 수 있다.
        if _auth == false {
            _auth = true
        }
        
        if mapController?.engineStarted == false {
            mapController?.startEngine()    //엔진 시작 및 렌더링 준비. 준비가 끝나면 MapControllerDelegate의 addViews 가 호출된다.
            mapController?.startRendering() //렌더링 시작.
        }
    }
    
    // 인증 실패시 호출.
    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("error code: \(errorCode)")
        print("desc: \(desc)")
        _auth = false
        switch errorCode {
        case 400:
            self.view.makeToast("지도 종료(API인증 파라미터 오류)")
            break;
        case 401:
            self.view.makeToast("지도 종료(API인증 키 오류)")
            break;
        case 403:
            self.view.makeToast("지도 종료(API인증 권한 오류)")
            break;
        case 429:
            self.view.makeToast("지도 종료(API 사용쿼터 초과)")
            break;
        case 499:
            self.view.makeToast("지도 종료(네트워크 오류) 5초 후 재시도..")
            
            // 인증 실패 delegate 호출 이후 5초뒤에 재인증 시도..
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                print("retry auth...")
                
                self.mapController?.authenticate()
            }
            break;
        default:
            break;
        }
    }
    
    func addViews() {
        print("addViews")
        let defaultPosition: MapPoint = MapPoint(longitude: CampusManager.shared.campus!.latitude, latitude: CampusManager.shared.campus!.longitude)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 16)
        
        mapController?.addView(mapviewInfo)
        
        
    }
    
    func createLabelLayer() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .all, competitionUnit: .poi, orderType: .rank, zOrder: 1000)
        let _ = manager.addLabelLayer(option: layerOption)
    }
   
    func createPoiStyle() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
       
        let normalIcon = PoiIconStyle(symbol:imageResize(image: UIImage(named: "mapPin")!, newWidth: 20, newHeight: 25), anchorPoint: CGPoint(x: 0.5, y: 0.5))
        let normalText = PoiTextStyle(textLineStyles: [PoiTextLineStyle(textStyle: TextStyle(fontSize: 30, fontColor: UIColor.white))])
        normalText.textLayouts = [.center]
        let normalPoiStyle = PoiStyle(styleID: "NormalStyle", styles: [PerLevelPoiStyle(iconStyle: normalIcon, textStyle: normalText, level: 0)])
        
        let selectIcon = PoiIconStyle(symbol:imageResize(image: UIImage(named: "selectedMapPin")!, newWidth: 30, newHeight: 35), anchorPoint: CGPoint(x: 0.5, y: 0.5))
        let selectText = PoiTextStyle(textLineStyles: [PoiTextLineStyle(textStyle: TextStyle(fontSize: 35, fontColor: UIColor.black))])
        selectText.textLayouts = [.center]
        let selectPoiStyle = PoiStyle(styleID: "SelectStyle", styles: [PerLevelPoiStyle(iconStyle: selectIcon, textStyle: selectText, level: 0)])
        
        manager.addPoiStyle(normalPoiStyle)
        manager.addPoiStyle(selectPoiStyle)
        
        input.send(.viewDidLoad)
    }
    func createPois() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        var poiOptionList: [PoiOptions] = []
        var pointList: [MapPoint] = []
        
        for i in 0..<restaurantList.count {
            let poiOption = PoiOptions(styleID: "NormalStyle", poiID: i.description)
            poiOption.rank = restaurantList[i].scrapCount ?? 0
            poiOption.addText(PoiText(text: restaurantList[i].scrapCount?.description ?? "0", styleIndex: 0))
            poiOption.clickable = true
           
            poiOptionList.append(poiOption)
            pointList.append(MapPoint(longitude: Double(restaurantList[i].latitude!)!, latitude:  Double(restaurantList[i].longitude!)!))
        }
       
        if let poiList = layer?.addPois(options: poiOptionList, at: pointList) {
            poiList.forEach {
                let _ = $0.addPoiTappedEventHandler(target: self, handler: MapViewController.poiTap(_:))
            }
        }
       
        
        layer?.showAllPois()
    }
    
    func returnNormalPoi() {
        selectId = nil
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        if let poiList = layer?.getAllPois() {
            poiList.forEach {
                $0.changeStyle(styleID: "NormalStyle")
            }
        }
    }
    
    
    func poiTap(_ param: PoiInteractionEventParam) {
        returnNormalPoi()
        selectId = Int(param.poiItem.itemID)!
        let view = mapController?.getView("mapview") as! KakaoMap
        view.moveCamera(CameraUpdate.make(target: MapPoint(longitude: Double(restaurantList[selectId!].latitude!)!, latitude: Double(restaurantList[selectId!].longitude!)!), zoomLevel: 17, rotation: 0, tilt: 0.0, mapView: view))
        
        param.poiItem.changeStyle(styleID: "SelectStyle", enableTransition: true)
        input.send(.tapPoi(restaurantList[Int(param.poiItem.itemID)!]))
    }
    
    func changePoiText(heart: Bool) {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        let poi = layer?.getPoi(poiID: selectId!.description)
        var count = restaurantList[selectId!].scrapCount ?? 0
        if heart {
            count += 1
        }else {
            count -= 1
        }
        poi?.changeTextAndStyle(texts: [PoiText(text: count.description, styleIndex: 0)], styleID: "SelectStyle")
    }
    

    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        let view = mapController?.getView("mapview") as! KakaoMap
        if UIDevice.current.hasNotch {
            view.setLogoPosition(origin: GuiAlignment(vAlign: .bottom, hAlign: .right), position: CGPoint(x: 3, y: 121))
        }else {
            view.setLogoPosition(origin: GuiAlignment(vAlign: .bottom, hAlign: .right), position: CGPoint(x: 3, y: 91))
        }
        
        createLabelLayer()
        createPoiStyle()
    }
    
    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
        mapView?.moveCamera(CameraUpdate.make(target: MapPoint(longitude: CampusManager.shared.campus!.latitude, latitude: CampusManager.shared.campus!.longitude), zoomLevel: 6, rotation: 0, tilt: 0.0, mapView: mapView!))
    }

    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    
        _observerAdded = true
    }
     
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)

        _observerAdded = false
    }

    @objc func willResignActive(){
        mapController?.stopRendering()
    }

    @objc func didBecomeActive(){
        mapController?.startRendering()
    }
    
    func bind() {
        let output = viewModel.trastfrom(input.eraseToAnyPublisher())
        
        output.receive(on: DispatchQueue.main).sink { [weak self] event in
            switch event {
            case .updateMap(let result):
                self?.restaurantList = result
                self?.createPois()
            case .loadInfoView(let heart, let isHeart, let id):
                let mapInfoView = MapInfoView()
                if self?.mapInfoView != nil {
                    self?.mapInfoView.removeFromSuperview()
                }
                
                self?.mapInfoView = mapInfoView.configure(heart: heart, isHeart: isHeart, id: id, input: self!.input)
                
                let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(self?.handleSwipeGesture(_:)))
                swipeDownGesture.direction = .down
                mapInfoView.addGestureRecognizer(swipeDownGesture)
                
                let height = UIScreen.main.bounds.height
                
                self?.view.addSubview(self!.mapInfoView)
                self?.mapInfoView.snp.makeConstraints {
                    $0.bottom.equalToSuperview()
                    $0.leading.equalToSuperview()
                    $0.trailing.equalToSuperview()
                    $0.height.equalTo(height/3+20)
                }
                
            case .moveToCall(let url, let isUrl):
                if isUrl {
                    if let openApp = URL(string: url), UIApplication.shared.canOpenURL(openApp) {
                        if #available(iOS 10.0, *) { UIApplication.shared.open(openApp, options: [:], completionHandler: nil) }
                        else { UIApplication.shared.openURL(openApp) }
                    }
                    else { self?.view.makeToast("번호가 등록되어있지 않습니다!")}
                }else {
                    self?.view.makeToast("번호가 등록되어있지 않습니다!")
                }
                break
            case .postHeart(let id):
                guard let mapInfoView = self?.mapInfoView as? MapInfoView else {return}
                mapInfoView.setId(id: id)
                mapInfoView.reloadDataAnimation(isHeart: true)
                self?.view.makeToast("찜꽁리스트에 추가되었습니다.💙")
                self?.changePoiText(heart: true)
                break
            case .cancelHeart(_):
                guard let mapInfoView = self?.mapInfoView as? MapInfoView else {return}
                mapInfoView.setId(id: nil)
                mapInfoView.reloadDataAnimation(isHeart: false)
                self?.view.makeToast("찜꽁리스트에서 삭제되었습니다.🥲")
                self?.changePoiText(heart: false)
                break
            }
        }.store(in: &cancellabels)
    }
                                                        
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        returnNormalPoi()
       if gesture.direction == .down {
           UIView.animate(withDuration: 0.2, animations: {
               self.mapInfoView.alpha = 0
           }, completion: { _ in
               self.mapInfoView.removeFromSuperview()
           })
       }
   }
    
    
    private func imageResize(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
          
        return renderImage
    }
    
    
    private func pinImage(text: String) -> UIImage? {
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
    
}
