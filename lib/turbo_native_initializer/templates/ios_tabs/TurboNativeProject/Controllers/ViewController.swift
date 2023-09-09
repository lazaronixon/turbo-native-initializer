import UIKit
import Turbo

final class ViewController: VisitableViewController, ErrorPresenter {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.backButtonDisplayMode = .minimal

        if presentingViewController != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissModal))
        }
    }

    @objc func dismissModal() {
        dismiss(animated: true)
    }
}
