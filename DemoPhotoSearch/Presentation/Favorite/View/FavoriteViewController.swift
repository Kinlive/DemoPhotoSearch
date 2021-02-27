//
//  FavoriteViewController.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteViewController: UIViewController {

    static func instantiate(viewModel: FavoriteViewModel) -> FavoriteViewController {
        let vc = FavoriteViewController()
        vc.view.backgroundColor = .white
        vc.viewModel = viewModel
        vc.bindViewModel()
        return vc
    }

    lazy var photosCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(PhotosResultCell.self, forCellWithReuseIdentifier: PhotosResultCell.storyboardIdentifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self

        collection.backgroundColor = .systemGray6

      return collection
    }()

    var viewModel: FavoriteViewModel!
    private let photos: BehaviorRelay<[Photo]> = BehaviorRelay(value: [])
    private var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(photosCollectionView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutConstraint()
    }

    private func layoutConstraint() {

        photosCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        photosCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    func bindViewModel() {

        let input = FavoriteInput(viewWillAppear: rx.viewWillAppear.asObservable())

        let output = viewModel.transform(input: input)

        output.photos
            .observeOn(MainScheduler.instance)
            .do(afterNext: { [weak self] _ in self?.photosCollectionView.reloadData() })
            .bind(to: photos)
            .disposed(by: bag)
    }
}

// MARK: - UICollectionView dataSource & delegate
extension FavoriteViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemHeight = collectionView.frame.height * 0.33
    return CGSize(width: itemHeight, height: itemHeight)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotosResultCell = collectionView.dequeueReusableCell(for: indexPath)

        let photo = photos.value[indexPath.row]
        cell.configure(photo: photo)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.value.count
    }
}

extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Bool> {
        let source = methodInvoked(#selector(Base.viewWillAppear(_:)))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}
