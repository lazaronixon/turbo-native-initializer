import Foundation
import Strada
import UIKit

final class NavButtonComponent: BridgeComponent {
    override class var name: String { "nav-button" }

    override func onReceive(message: Message) {
        guard let event = Event(rawValue: message.event) else {
            return
        }

        if event == .connect {
            handleConnectEvent(message: message)
        }
    }

    @objc func performAction() {
        reply(to: Event.connect.rawValue)
    }

    // MARK: Private

    private weak var navBarButtonItem: UIBarButtonItem?

    private var viewController: UIViewController? {
        delegate.destination as? UIViewController
    }

    private func handleConnectEvent(message: Message) {
        guard let data: MessageData = message.data() else { return }
        configureBarButton(with: data.title)
    }

    private func configureBarButton(with title: String) {
        guard let viewController else { return }

        let item = UIBarButtonItem(title: title,
                                   style: .plain,
                                   target: self,
                                   action: #selector(performAction))

        viewController.navigationItem.rightBarButtonItem = item
        navBarButtonItem = item
    }
}

// MARK: Events

private extension NavButtonComponent {
    enum Event: String { case connect }
}

// MARK: Message data

private extension NavButtonComponent {
    struct MessageData: Decodable {
        let title: String
    }
}
