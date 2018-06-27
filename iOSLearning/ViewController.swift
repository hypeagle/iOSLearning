//
//  ViewController.swift
//  iOSLearning
//
//  Created by 黄怡平 on 2018/1/21.
//  Copyright © 2018年 黄怡平. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    
    @IBAction func startLocate(_ sender: UIButton) {
        locateMap()
    }
    
    func locateMap() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5.0
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失败")
        
        let alter = UIAlertController(title: "提示", message: "请在设置中打开定位", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "打开定位", style: UIAlertActionStyle.default) { (_) in
            let url = URL(fileURLWithPath: UIApplicationOpenSettingsURLString)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        alter.addAction(cancel)
        alter.addAction(ok)
        self.present(alter, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        print("定位成功")
        
        if let location = locations.last {
            print(location.coordinate.latitude, location.coordinate.longitude)
            
            let locationAge = -location.timestamp.timeIntervalSinceNow
            print(locationAge)
            
            let geo = CLGeocoder()
            geo.reverseGeocodeLocation(location) { (placeMarks, error) in
                if let placeMark = placeMarks?.first {
                    let str: String = "当前国家：\(placeMark.country ?? "")\n当前城市：\(placeMark.locality ?? "")\n当前位置：\(placeMark.subLocality ?? "")\n当前街道：\(placeMark.thoroughfare ?? "")\n具体位置：\(placeMark.name ?? "")"
                    print(str)
                    let alter = UIAlertController(title: "定位成功", message: str, preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil)
                    alter.addAction(ok)
                    self.present(alter, animated: true, completion: nil)
                }
            }
        }
    }
}

