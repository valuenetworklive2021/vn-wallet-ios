//
// Created by James Sangalli on 8/12/18.
//

import Foundation
import UIKit

protocol DappsHome2ViewControllerDelegate: AnyObject {
    func didTapPredictionMarketsViewController2(inViewController viewController: DappsHome2ViewController)
    func didTapShowMyDappsViewController2(inViewController viewController: DappsHome2ViewController)
    func didTapShowBrowserHistoryViewController2(inViewController viewController: DappsHome2ViewController)
    func didTapShowDiscoverDappsViewController2(inViewController viewController: DappsHome2ViewController)
    func didTap2(dapp: Bookmark, inViewController viewController: DappsHome2ViewController)
    func delete2(dapp: Bookmark, inViewController viewController: DappsHome2ViewController)
    func viewControllerWillAppear2(_ viewController: DappsHome2ViewController)
    func dismissKeyboard2(inViewController viewController: DappsHome2ViewController)
}

class DappsHome2ViewController: UIViewController {
    private var isEditingDapps = false {
        didSet {
            dismissKeyboard2()
            if isEditingDapps {
                if !oldValue {
                    let vibration = UIImpactFeedbackGenerator()
                    vibration.prepare()
                    vibration.impactOccurred()
                }
                //TODO should this be a state case in the nav bar, but with a flag (associated value?) whether to disable the buttons?
                browserNavBar?.disableButtons()
                guard timerToCheckIfStillEditing == nil else { return }

                timerToCheckIfStillEditing = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                    guard let strongSelf = self else { return }
                    if strongSelf.isTopViewController {
                    } else {
                        strongSelf.isEditingDapps = false
                    }
                }
            } else {
                //TODO should this be a state case in the nav bar, but with a flag (associated value?) whether to disable the buttons?
                browserNavBar?.enableButtons()

                timerToCheckIfStillEditing?.invalidate()
                timerToCheckIfStillEditing = nil
            }
            dappsCollectionView.reloadData()
        }
    }
    private var timerToCheckIfStillEditing: Timer?
    private var viewModel: DappsHome2ViewControllerViewModel
    private var browserNavBar: DappBrowserNavigationBar? {
        return navigationController?.navigationBar as? DappBrowserNavigationBar
    }
    lazy private var dappsCollectionView = { () -> UICollectionView in
        let layout = UICollectionViewFlowLayout()
        let fixedGutter = CGFloat(24)
        let availableWidth = UIScreen.main.bounds.size.width - (2 * fixedGutter)
        let numberOfColumns: CGFloat
        if ScreenChecker().isBigScreen {
            numberOfColumns = 6
        } else {
            numberOfColumns = 3
        }
        let dimension = (availableWidth / numberOfColumns).rounded(.down)
        //Using a sizing cell doesn't get the same reason after we change network. Resorting to hardcoding the width and height difference
        let itemSize = CGSize(width: dimension, height: dimension + 30)
        let additionalGutter = (availableWidth - itemSize.width * numberOfColumns) / (numberOfColumns + 1)
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .init(top: 0, left: additionalGutter + fixedGutter, bottom: 0, right: additionalGutter + fixedGutter)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private let bookmarksStore: BookmarksStore
    weak var delegate: DappsHome2ViewControllerDelegate?

    init(bookmarksStore: BookmarksStore) {
        self.bookmarksStore = bookmarksStore
        self.viewModel = .init(bookmarksStore: bookmarksStore)
        super.init(nibName: nil, bundle: nil)

        dappsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        dappsCollectionView.alwaysBounceVertical = true
        dappsCollectionView.registerSupplementaryView(DappsHome2ViewControllerHeaderView.self, of: UICollectionView.elementKindSectionHeader)
        dappsCollectionView.register(DappViewCell.self)
        dappsCollectionView.dataSource = self
        dappsCollectionView.delegate = self
        view.addSubview(dappsCollectionView)

        NSLayoutConstraint.activate([
            dappsCollectionView.anchorsConstraint(to: view)
        ])
        configure(viewModel: viewModel)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.viewControllerWillAppear2(self)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardEndFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let _ = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
            dappsCollectionView.contentInset.bottom = keyboardEndFrame.size.height
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if let _ = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, let _ = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
            dappsCollectionView.contentInset.bottom = 0
        }
    }

    func configure(viewModel: DappsHome2ViewControllerViewModel) {
        self.viewModel = viewModel
        view.backgroundColor = viewModel.backgroundColor
        dappsCollectionView.backgroundColor = viewModel.backgroundColor

        dappsCollectionView.reloadData()
    }

    @objc private func showPredictionMarketsViewController() {
        dismissKeyboard2()
        delegate?.didTapPredictionMarketsViewController2(inViewController: self)
    }

    @objc private func showMyDappsViewController() {
        dismissKeyboard2()
        delegate?.didTapShowMyDappsViewController2(inViewController: self)
    }

    @objc private func showBrowserHistoryViewController() {
        dismissKeyboard2()
        delegate?.didTapShowBrowserHistoryViewController2(inViewController: self)
    }

    private func dismissKeyboard2() {
        delegate?.dismissKeyboard2(inViewController: self)
    }
}

extension DappsHome2ViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0// viewModel.dappsCount
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dapp = viewModel.dapp(atIndex: indexPath.item)
        let cell: DappViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        cell.configure(viewModel: .init(dapp: dapp))
        cell.isEditing = isEditingDapps
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: DappsHome2ViewControllerHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
        headerView.delegate = self
        headerView.configure(viewModel: .init(isEditing: isEditingDapps))
        headerView.predictionMarketsButton.addTarget(self, action: #selector(showPredictionMarketsViewController), for: .touchUpInside)
        headerView.myDappsButton.addTarget(self, action: #selector(showMyDappsViewController), for: .touchUpInside)
        headerView.historyButton.addTarget(self, action: #selector(showBrowserHistoryViewController), for: .touchUpInside)
        return headerView
    }
}

extension DappsHome2ViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dappsCollectionView.deselectItem(at: indexPath, animated: true)
        dismissKeyboard2()
        let dapp = viewModel.dapp(atIndex: indexPath.item)
        delegate?.didTap2(dapp: dapp, inViewController: self)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerView = DappsHome2ViewControllerHeaderView()
        headerView.configure()
        let size = headerView.systemLayoutSizeFitting(.init(width: collectionView.frame.size.width, height: 1000))
        return size
    }
}

extension DappsHome2ViewController: DappViewCellDelegate {
    func didTapDelete(dapp: Bookmark, inCell cell: DappViewCell) {
        confirm(
                title: R.string.localizable.dappBrowserClearMyDapps(),
                message: dapp.title,
                okTitle: R.string.localizable.removeButtonTitle(),
                okStyle: .destructive
        ) { [weak self] result in
            switch result {
            case .success:
                guard let strongSelf = self else { return }
                strongSelf.delegate?.delete2(dapp: dapp, inViewController: strongSelf)
            case .failure:
                break
            }
        }
    }

    func didLongPressed(dapp: Bookmark, onCell cell: DappViewCell) {
        isEditingDapps = true
    }
}

extension DappsHome2ViewController: DappsHome2ViewControllerHeaderViewDelegate {
    func didExitEditMode(inHeaderView: DappsHome2ViewControllerHeaderView) {
        isEditingDapps = false
    }
}
