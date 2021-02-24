//
//  FavoriteViewController.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import UIKit

class FavoriteViewController: UIViewController {

    static func instantiate(viewModel: FavoriteViewModel) -> FavoriteViewController {
        let vc = FavoriteViewController()
        vc.view.backgroundColor = .white
        vc.viewModel = viewModel
        return vc
    }

    var viewModel: FavoriteViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
