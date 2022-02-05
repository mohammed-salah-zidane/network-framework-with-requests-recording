//
//  ViewController.swift
//  InstabugInterview
//
//  Created by Yousef Hamza on 1/13/21.
//

import UIKit
import InstabugNetworkClient

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myGroup = DispatchGroup()
        
        myGroup.enter()
        NetworkClient.shared.get(URL(string: "https://httpbin.org/get")!) { data in
            myGroup.leave()
        }
    
        myGroup.notify(queue: .global()) {
            NetworkClient.shared.allNetworkRequests { requests in
                print("requests count is ", requests.count)
            }
        }
        //print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
    }
}

