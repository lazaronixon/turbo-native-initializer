import SwiftUI

public extension UIViewController {
    func presentToast(_ message: String) {
        guard let root = view.window?.rootViewController else { return }

        removeToastViews(from: root)

        let toastView = ToastView(message: message)
        toastView.translatesAutoresizingMaskIntoConstraints = false

        root.view.addSubview(toastView)

        NSLayoutConstraint.activate([
            toastView.topAnchor.constraint(equalTo: root.view.safeAreaLayoutGuide.topAnchor),
            toastView.centerXAnchor.constraint(equalTo: root.view.centerXAnchor)
        ])

        let widthConstraint = toastView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10)
        widthConstraint.priority = .defaultHigh

        let maxWidthConstraint = toastView.widthAnchor.constraint(lessThanOrEqualToConstant: 600)
        maxWidthConstraint.priority = .required

        NSLayoutConstraint.activate([
            widthConstraint, maxWidthConstraint
        ])
    }

    fileprivate func removeToastViews(from root: UIViewController) {
        root.view.subviews.filter({ $0 is ToastView }).forEach({ toast in
            toast.removeFromSuperview()
        })
    }
}

public class ToastView: UIView {

    private var duration = 2.5

    convenience init(message: String) {
        self.init(frame: .zero)

        self.alpha = .zero
        self.backgroundColor = .black
        self.layer.cornerRadius = 10

        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(messageLabel)

        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))

        UIView.animate(withDuration: 0.5, delay: .zero, options: .curveEaseIn, animations: {
            self.alpha = 0.9
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + self.duration) { self.dismiss() }
        })
    }

    @objc private func dismiss() {
        UIView.animate(withDuration: 0.5, delay: .zero, options: .curveEaseOut, animations: {
            self.alpha = .zero
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
