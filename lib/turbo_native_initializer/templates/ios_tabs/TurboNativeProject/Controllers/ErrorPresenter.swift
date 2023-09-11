import SwiftUI
import UIKit

public protocol ErrorPresenter: UIViewController {
    func presentError(_ error: Error, handler: @escaping () -> Void)
}

public extension ErrorPresenter {
    func presentError(_ error: Error, handler: @escaping () -> Void) {
        let errorView = ErrorView(error: error) { [unowned self] in
            handler(); self.removeErrorViewController()
        }

        let controller = UIHostingController(rootView: errorView)
        addChild(controller)
        addFullScreenSubview(controller.view)
        controller.didMove(toParent: self)
    }

    private func removeErrorViewController() {
        if let child = children.first(where: { $0 is UIHostingController<ErrorView> }) {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }

    private func addFullScreenSubview(_ subview: UIView) {
        view.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subview.topAnchor.constraint(equalTo: view.topAnchor),
            subview.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

struct ErrorView: View {
    let error: Error
    let handler: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Text("Error loading page")
                .font(.largeTitle)

            Text(error.localizedDescription)
                .font(.body)
                .multilineTextAlignment(.center)

            Button("Retry") {
                handler?()
            }
            .font(.system(size: 17, weight: .bold))
        }
        .padding(32)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        return ErrorView(error: NSError(
            domain: "com.example.error",
            code: 1001,
            userInfo: [NSLocalizedDescriptionKey: "Could not connect to the server."]
        )) {}
    }
}
