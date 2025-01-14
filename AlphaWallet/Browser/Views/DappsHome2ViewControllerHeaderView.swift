// Copyright © 2018 Stormbird PTE. LTD.

import Foundation
import UIKit

protocol DappsHome2ViewControllerHeaderViewDelegate: AnyObject {
    func didExitEditMode(inHeaderView: DappsHome2ViewControllerHeaderView)
}

class DappsHome2ViewControllerHeaderView: UICollectionReusableView {
    private let stackView = [].asStackView(axis: .vertical, contentHuggingPriority: .required, alignment: .center)
    private let headerView = DappsHomeHeaderView()
    private let exitEditingModeButton = UIButton(type: .system)

    weak var delegate: DappsHome2ViewControllerHeaderViewDelegate?
    let predictionMarketsButton = DappButton()
    let myDappsButton = DappButton()
    let historyButton = DappButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let buttonsStackViewTop = [
            predictionMarketsButton
        ].asStackView(distribution: .equalSpacing, contentHuggingPriority: .required)

        let buttonsStackView = [
            myDappsButton,
            .spacerWidth(40),
            historyButton
        ].asStackView(distribution: .equalSpacing, contentHuggingPriority: .required)

        exitEditingModeButton.addTarget(self, action: #selector(exitEditMode), for: .touchUpInside)
        exitEditingModeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(exitEditingModeButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubviews([
            //headerView,
            //.spacer(height: 5),
            buttonsStackViewTop,
            //.spacer(height: 30),
            //buttonsStackView,
        ])
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: exitEditingModeButton.topAnchor, constant: -10),

            myDappsButton.widthAnchor.constraint(equalTo: historyButton.widthAnchor),

            exitEditingModeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            exitEditingModeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModel: DappsHome2ViewControllerHeaderViewViewModel = .init(isEditing: false)) {
        backgroundColor = viewModel.backgroundColor

        headerView.configure(viewModel: .init(title: viewModel.title))

        predictionMarketsButton.configure(viewModel: .init(image: viewModel.predictionMarketsButtonImage, title: viewModel.predictionMarketsButtonTitle))

        myDappsButton.configure(viewModel: .init(image: viewModel.myDappsButtonImage, title: viewModel.myDappsButtonTitle))

        historyButton.configure(viewModel: .init(image: viewModel.historyButtonImage, title: viewModel.historyButtonTitle))

        if viewModel.isEditing {
            exitEditingModeButton.isHidden = false
            exitEditingModeButton.setTitle(R.string.localizable.done().localizedUppercase, for: .normal)
            exitEditingModeButton.titleLabel?.font = Fonts.bold(size: 12)

            predictionMarketsButton.isEnabled = false
            myDappsButton.isEnabled = false
            historyButton.isEnabled = false
        } else {
            exitEditingModeButton.isHidden = true

            predictionMarketsButton.isEnabled = true
            myDappsButton.isEnabled = true
            historyButton.isEnabled = true
        }
    }

    @objc private func exitEditMode() {
        configure(viewModel: .init(isEditing: false))
        delegate?.didExitEditMode(inHeaderView: self)
    }
}
