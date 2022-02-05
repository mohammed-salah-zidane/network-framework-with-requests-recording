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
            
        for i in 1...1000 {
            NetworkClient.shared.get(URL(string: "https://httpbin.org/get")!) { data in
                NetworkClient.shared.allNetworkRequests { requests in
                    print("recorded requests: ",requests.count)
                }
            }
        }

        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
    }
}

