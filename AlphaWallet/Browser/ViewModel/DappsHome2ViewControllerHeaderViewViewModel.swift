// Copyright © 2018 Stormbird PTE. LTD.

import Foundation
import UIKit

struct DappsHome2ViewControllerHeaderViewViewModel {
    let isEditing: Bool

    var backgroundColor: UIColor {
        return Colors.appWhite
    }

    var title: String {
        return R.string.localizable.dappBrowserTitle()
    }

    var predictionMarketsButtonImage: UIImage? {
        return R.image.tab_predictions()
    }

    var predictionMarketsButtonTitle: String {
        return R.string.localizable.predictionMarketsImageLabel()
    }

    var myDappsButtonImage: UIImage? {
        return R.image.myDapps()
    }

    var myDappsButtonTitle: String {
        return R.string.localizable.myDappsButtonImageLabel()
    }

    var historyButtonImage: UIImage? {
        return R.image.history()
    }

    var historyButtonTitle: String {
        return R.string.localizable.historyButtonImageLabel()
    }
}
