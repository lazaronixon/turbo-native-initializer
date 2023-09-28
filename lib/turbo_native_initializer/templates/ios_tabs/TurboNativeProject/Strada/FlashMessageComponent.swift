import Foundation
import Strada
import UIKit

final class FlashMessageComponent: BridgeComponent {
    override class var name: String { "flash-message" }

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

    private var viewController: UIViewController? {
        delegate.destination as? UIViewController
    }

    private func handleConnectEvent(message: Message) {
        guard let data: MessageData = message.data() else { return }
        guard let viewController else { return }        
        viewController.parent?.presentToast(data.title)
    }
}

// MARK: Events

private extension FlashMessageComponent {
    enum Event: String { case connect }
}

// MARK: Message data

private extension FlashMessageComponent {
    struct MessageData: Decodable {
        let title: String
    }
}
