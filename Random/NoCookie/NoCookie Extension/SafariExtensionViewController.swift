//
//  SafariExtensionViewController.swift
//  NoCookie Extension
//
//  Created by Matt Hogg on 24/06/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:320, height:240)
        return shared
    }()

}
