//
//  SearchViewController.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import UIKit

class SearchViewController: UIViewController {

    static func instantiate(viewModel: SearchViewModel) -> SearchViewController {
        let vc = SearchViewController()
        vc.view.backgroundColor = .white
        vc.viewModel = viewModel

        return vc
    }

    var viewModel: SearchViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

