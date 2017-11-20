//
//  DetailViewController.swift
//  Presidents
//
//  Created by FangChen on 2017/11/20.
//  Copyright © 2017年 FangChen. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    private var languageListController:LangguageListControllerTableViewController?
    var languageButton: UIBarButtonItem?
    //var languageString = ""
    

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                let dict = detail
                //let urlString = dict["url"]
                let urlString = modifyUrlForLnaguage(url: dict["url"]!, language: languageString)
                label.text = urlString
                
                let url = NSURL(string: urlString)!
                let request = URLRequest(url:url as URL)
                webView.load(request)
                let name = dict["name"]
                title = name
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        languageButton = UIBarButtonItem(title:"Choose Language",style:.plain,target:self,action:#selector(DetailViewController.showLanguagePopover))
        navigationItem.rightBarButtonItem = languageButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var languageString = ""{
        didSet{
            if languageString != oldValue{
                configureView()
            }
        }
    }
    
    @objc func showLanguagePopover(){
        if languageListController == nil {
            languageListController = LangguageListControllerTableViewController()
            languageListController!.detailViewController = self
            languageListController!.modalPresentationStyle = .popover
        }
        
        present(languageListController!,animated: true,completion: nil)
        if let ppc = languageListController?.popoverPresentationController{
            ppc.barButtonItem = languageButton
        }
    }
    
    var detailItem: [String:String]? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    private func modifyUrlForLnaguage(url:String,language lang:String?) -> String{
        var newUrl = url
        if let langStr = lang {
            let range = NSMakeRange(8, 2)
            if !langStr.isEmpty && (url as NSString).substring(with: range) != langStr{
                newUrl = (url as NSString).replacingCharacters(in:range,with:langStr)
            }
        }
        
        return newUrl
    }
}

