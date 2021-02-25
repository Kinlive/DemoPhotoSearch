//
//  SearchViewController.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import UIKit
import RxCocoa
import RxSwift

class SearchViewController: UIViewController {

    static func instantiate(viewModel: SearchViewModel) -> SearchViewController {
        let vc = SearchViewController()
        vc.view.backgroundColor = .white
        vc.viewModel = viewModel
        vc.bindViewModel()

        return vc
    }

    // MARK: - UIs
    lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "搜尋..."
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .systemGray5
        return tf
    }()

    lazy var perPageTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .systemGray5
        tf.placeholder = "輸入每頁顯示數量"
        return tf
    }()

    lazy var submitButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("搜尋", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.red, for: .disabled)
        btn.backgroundColor = .systemGray6
        return btn
    }()

    // MARK: - Properties
    var viewModel: SearchViewModel!
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addSubviews()

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutConstraint()
    }

    func bindViewModel() {

        let input = SearchViewModelInput(
            searchText: searchTextField.rx.text.orEmpty.asObservable(),
            perPages: perPageTextField.rx.text.orEmpty.asObservable(),
            submit: submitButton.rx.controlEvent(.touchUpInside)
                .map { _ in }
        )

        let output = viewModel.transform(input: input)

        output.canSearch
            .do(onNext: { [weak self] canSearch in
                self?.submitButton.backgroundColor = canSearch ? .systemOrange : .systemGray6
            })
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: bag)

    }

}

private extension SearchViewController {
    private func addSubviews() {
        view.addSubview(searchTextField)
        view.addSubview(perPageTextField)
        view.addSubview(submitButton)
    }

    private func layoutConstraint() {
        searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true

        perPageTextField.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 15).isActive = true
        perPageTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        perPageTextField.heightAnchor.constraint(equalTo: searchTextField.heightAnchor).isActive = true
        perPageTextField.widthAnchor.constraint(equalTo: searchTextField.widthAnchor).isActive = true

        submitButton.topAnchor.constraint(equalTo: perPageTextField.bottomAnchor, constant: 40).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submitButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }


}
