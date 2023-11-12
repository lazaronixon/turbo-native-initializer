import UIKit
import Turbo
import Strada
import WebKit

final class TurboWebViewController: VisitableViewController, ErrorPresenter, BridgeDestination {

    var pullToRefreshEnabled = true

    private lazy var bridgeDelegate: BridgeDelegate = {
        BridgeDelegate(location: visitableURL.absoluteString, destination: self, componentTypes: BridgeComponent.allTypes)
    }()

    private lazy var dismissModalButton = {
        UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(dismissModal))
    }()

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bridgeDelegate.onViewDidLoad()

        navigationItem.backButtonTitle = "Back"

        visitableView.allowsPullToRefresh = pullToRefreshEnabled

        if presentingViewController != nil {
            navigationItem.leftBarButtonItem = dismissModalButton
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bridgeDelegate.onViewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bridgeDelegate.onViewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bridgeDelegate.onViewWillDisappear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bridgeDelegate.onViewDidDisappear()
    }

    // MARK: Visitable

    override func visitableDidRender() {
        navigationItem.title = navigationItem.title ?? visitableView.webView?.title
    }

    override func visitableDidActivateWebView(_ webView: WKWebView) {
        bridgeDelegate.webViewDidBecomeActive(webView)
    }

    override func visitableDidDeactivateWebView() {
        bridgeDelegate.webViewDidBecomeDeactivated()
    }

    // MARK: Actions

    @objc func dismissModal() {
        dismiss(animated: true)
    }
}
