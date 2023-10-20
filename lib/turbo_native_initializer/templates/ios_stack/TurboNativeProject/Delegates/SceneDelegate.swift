import UIKit
import WebKit
import SafariServices
import Turbo
import Strada

final class SceneDelegate: UIResponder {

    var window: UIWindow?
    private let rootURL = TurboNativeProject.homeURL
    private var navigationController: TurboNavigationController!

    // MARK: - Setup

    private func configureRootViewController() {
        navigationController = window!.rootViewController as? TurboNavigationController
        navigationController.navigationBar.scrollEdgeAppearance = .init()
        navigationController.session = session
        navigationController.modalSession = modalSession
    }

    // MARK: - Authentication

    private func promptForAuthentication() {
        let authURL = TurboNativeProject.signInURL
        let properties = pathConfiguration.properties(for: authURL)
        navigationController.route(url: authURL, options: VisitOptions(), properties: properties)
    }

    // MARK: - Sessions

    private lazy var session = makeSession()
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

    // MARK: - Path Configuration

    private lazy var pathConfiguration = PathConfiguration(sources: [
        .file(Bundle.main.url(forResource: "path-configuration", withExtension: "json")!),
    ])
}

extension SceneDelegate: UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        configureRootViewController()
        navigationController.route(url: rootURL, options: VisitOptions(action: .replace), properties: [:])
    }
}

extension SceneDelegate: SessionDelegate {
    func session(_ session: Session, didProposeVisit proposal: VisitProposal) {
        navigationController.route(url: proposal.url, options: proposal.options, properties: proposal.properties)
    }

    func session(_ session: Session, openExternalURL url: URL) {
        if url.host == rootURL.host, !url.pathExtension.isEmpty {
            navigationController.present(SFSafariViewController(url: url), animated: true)
        } else {
            UIApplication.shared.open(url)
        }
    }

    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, error: Error) {
        if let turboError = error as? TurboError, case let .http(statusCode) = turboError, statusCode == 401 {
            promptForAuthentication()
        } else if let errorPresenter = visitable as? ErrorPresenter {
            errorPresenter.presentError(error) { session.reload() }
        } else {
            fatalError("Visit failed!")
        }
    }

    func sessionDidFinishFormSubmission(_ session: Session) {
        if (session == modalSession) {
            self.session.clearSnapshotCache()
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
        navigationController.present(confirm, animated: true)
    }
}
