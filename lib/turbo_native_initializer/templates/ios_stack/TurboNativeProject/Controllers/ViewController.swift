import UIKit
import Turbo

final class ViewController: VisitableViewController, ErrorPresenter {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backButtonTitle = "Back"

        if presentingViewController != nil {
            navigationItem.leftBarButtonItem = dismissModalButton
        }
    }

    private lazy var dismissModalButton = {
        UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissModal))
    }()

    @objc private func dismissModal() {
        dismiss(animated: true)
    }
}
