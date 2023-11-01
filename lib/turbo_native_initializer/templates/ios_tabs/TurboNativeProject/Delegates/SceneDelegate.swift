import UIKit
import WebKit
import SafariServices
import Turbo
import Strada

final class SceneDelegate: UIResponder {
    var window: UIWindow?

    private let baseURL  = TurboNativeProject.baseURL
    private let rootURL1 = TurboNativeProject.homeURL1
    private let rootURL2 = TurboNativeProject.homeURL2

    private var tabBarController: UITabBarController!
    private var navigationController1: TurboNavigationController!
    private var navigationController2: TurboNavigationController!

    private func navigationController() -> TurboNavigationController {
        tabBarController.selectedViewController as! TurboNavigationController
    }

    // MARK: - Setup

    private func configureRootViewController() {
        UINavigationBar.appearance().scrollEdgeAppearance = .init()

        navigationController1 = TurboNavigationController()
        navigationController1.tabBarItem = .init(title: nil, image: .init(systemName: "house"), tag: 0)
        navigationController1.session = session1
        navigationController1.modalSession = modalSession

        navigationController2 = TurboNavigationController()
        navigationController2.tabBarItem = .init(title: nil, image: .init(systemName: "house"), tag: 1)
        navigationController2.session = session2
        navigationController2.modalSession = modalSession

        UITabBar.appearance().scrollEdgeAppearance = .init()

        tabBarController = UITabBarController()
        tabBarController.viewControllers = [navigationController1, navigationController2]

        window!.rootViewController = tabBarController
    }

    // MARK: - Sessions

    private lazy var session1 = makeSession()
    private lazy var session2 = makeSession()

    private lazy var modalSession = makeSession()

    private func makeSession() -> Session {
        let webView = WKWebView(frame: .zero, configuration: .appConfiguration)
        webView.uiDelegate = self
        webView.allowsLinkPreview = false

        Bridge.initialize(webView) // Initialize Strada bridge.

        let session = Session(webView: webView)
        session.delegate = self
        session.pathConfiguration = pathConfiguration
        return session
    }

    private func session() -> Session {
        navigationController().session
    }

    // MARK: - Path Configuration

    private lazy var pathConfiguration = PathConfiguration(sources: [
        .file(Bundle.main.url(forResource: "path-configuration", withExtension: "json")!),
    ])
}

extension SceneDelegate: UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = scene as? UIWindowScene else { return }

        configureRootViewController()

        navigationController1.route(url: rootURL1, options: VisitOptions(action: .replace), properties: [:])
        navigationController2.route(url: rootURL2, options: VisitOptions(action: .replace), properties: [:])
    }
}

extension SceneDelegate: SessionDelegate {
    func session(_ session: Session, didProposeVisit proposal: VisitProposal) {
        navigationController().route(url: proposal.url, options: proposal.options, properties: proposal.properties)
    }

    func session(_ session: Session, openExternalURL url: URL) {
        if url.host == baseURL.host, !url.pathExtension.isEmpty {
            navigationController().present(SFSafariViewController(url: url), animated: true)
        } else {
            UIApplication.shared.open(url)
        }
    }

    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, error: Error) {
        if let errorPresenter = visitable as? ErrorPresenter {
            errorPresenter.presentError(error) { session.reload() }
        } else {
            fatalError("Visit failed!")
        }
    }

    func sessionDidFinishFormSubmission(_ session: Session) {
        if (session == modalSession) {
            self.session().clearSnapshotCache()
        }
    }

    func sessionWebViewProcessDidTerminate(_ session: Session) {
        session.reload()
    }
}

extension SceneDelegate: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let confirm = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        confirm.addAction(.init(title: "Cancel", style: .cancel) { _ in completionHandler(false) })
        confirm.addAction(.init(title: "OK", style: .default) { _ in completionHandler(true) })
        navigationController().present(confirm, animated: true)
    }
}
