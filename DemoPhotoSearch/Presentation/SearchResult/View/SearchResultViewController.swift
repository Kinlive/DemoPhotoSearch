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

    lazy var baseStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 0
        return stack
    }()

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

    lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let  act = UIActivityIndicatorView(style: .large)
        act.translatesAutoresizingMaskIntoConstraints = false
        act.color = .systemBlue
        act.stopAnimating()
        return act
    }()

    lazy var loadingBaseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.isHidden = true
        return view
    }()

    private var loadingHeightConstraints: NSLayoutConstraint!

    let bag = DisposeBag()
    var viewModel: SearchResultViewModel!

    let photos: BehaviorRelay<Photos?> = BehaviorRelay(value: nil)
    private let onScrollToBottom: PublishSubject<Void> = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(baseStackView)
        baseStackView.addArrangedSubview(photosCollectionView)
        baseStackView.addArrangedSubview(loadingBaseView)
        loadingBaseView.addSubview(loadingIndicatorView)

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutConstraint()
    }

    private func layoutConstraint() {

        baseStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        baseStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        baseStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        baseStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        loadingBaseView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        loadingIndicatorView.centerXAnchor.constraint(equalTo: loadingBaseView.centerXAnchor).isActive = true
        loadingIndicatorView.centerYAnchor.constraint(equalTo: loadingBaseView.centerYAnchor).isActive = true
    }

    private func showSave(indexPath: IndexPath) {
        let alert = UIAlertController(title: "加入最愛", message: "已將 \(indexPath) 加入最愛", preferredStyle: .alert)
        let ok = UIAlertAction(title: "確認", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    func bindViewModel() {

        let bottomAndTopEdge: CGFloat = 50
        let onScrolling = photosCollectionView.rx.delegate.sentMessage(#selector(UIScrollViewDelegate.scrollViewDidEndDragging(_:willDecelerate:)))
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .map { [weak self] _ -> CGFloat in
                guard let `self` = self else { return 0 }
                return self.photosCollectionView.contentOffset.y
            }
            .filter { [weak self] _ in self?.photos.value != nil }
            .share()

        // scroll to top
        let onScrollingToTop = onScrolling
            .filter { $0 <= -bottomAndTopEdge }

        let triggerReload = Observable.merge(
            onScrollingToTop.map { _ in },
            rx.viewDidLoad.asObservable()
        )


        // scroll to bottom
        let onScrollingToBottom = onScrolling
            .map { [weak self] offsetY in
                guard let `self` = self else { return false }
                let bottomEdge = (offsetY + self.photosCollectionView.frame.height)
                return bottomEdge >= (self.photosCollectionView.contentSize.height + bottomAndTopEdge)
            }
            .filter { $0 }

        onScrollingToBottom
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.loadingBaseView.isHidden = false
            })
            .delay(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(to: loadingIndicatorView.rx.isAnimating)
            .disposed(by: bag)

        let savePhoto = photosCollectionView.rx.itemSelected.asObservable()

        let output = viewModel.transform(input: .init(
            fetchPhotos: triggerReload,
            photoSelected: savePhoto,
            scrollToBottom: onScrollingToBottom)
        )

        output.photos
            .do(afterNext: { [weak self] _ in
                self?.photosCollectionView.reloadData()
                self?.loadingBaseView.isHidden = true
            })
            .bind(to: photos)
            .disposed(by: bag)

        output.saved
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                self?.showSave(indexPath: indexPath)
            })
            .disposed(by: bag)

    }

}

// MARK: - UICollectionView dataSource & delegate
extension SearchResultViewController: UICollectionViewDelegateFlowLayout {

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

extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
}
