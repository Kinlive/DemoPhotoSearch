//
//  SearchResultViewController.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import UIKit
import RxCocoa
import RxSwift

class SearchResultViewController: UIViewController {

    static func instantiate(viewModel: SearchResultViewModel) -> SearchResultViewController {
        let vc = SearchResultViewController()
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

      collection.backgroundColor = .lightGray

      return collection
    }()

    let bag = DisposeBag()
    var viewModel: SearchResultViewModel!

    let photos: BehaviorRelay<Photos?> = BehaviorRelay(value: nil)
    private let onScrollToBottom: PublishSubject<Void> = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

        let output = viewModel.transform(input: .init(photoSelected: .init(), scrollToBottom: onScrollToBottom))

        output.photos
            .do(afterNext: { [weak self] _ in self?.photosCollectionView.reloadData() })
            .bind(to: photos)
            .disposed(by: bag)

    }

}

// MARK: - UICollectionView dataSource & delegate
extension SearchResultViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemHeight = collectionView.frame.height * 0.33
    let itemWidth = collectionView.frame.width * 0.5
    return CGSize(width: itemWidth, height: itemHeight)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

  }
}

extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotosResultCell = collectionView.dequeueReusableCell(for: indexPath)

        if let photo = photos.value?.photo[indexPath.row] {
            cell.configure(photo: photo)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.value?.photo.count ?? 0
    }
}

extension SearchResultViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= (scrollView.contentSize.height + 50) {
            print("At bottom trigger fetch next page's phots.")
            onScrollToBottom.onNext(())
        }
    }
}
