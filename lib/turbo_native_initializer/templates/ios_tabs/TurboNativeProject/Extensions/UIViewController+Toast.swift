import SwiftUI

public extension UIViewController {
    func presentToast(_ message: String) {
        guard let window = view.window else { return }

        removeToastViews(from: window)

        let toastView = ToastView(message: message)
        toastView.translatesAutoresizingMaskIntoConstraints = false

        window.addSubview(toastView)

        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            toastView.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 2),
            toastView.widthAnchor.constraint(equalTo: window.safeAreaLayoutGuide.widthAnchor, constant: -10)
        ])
    }

    fileprivate func removeToastViews(from window: UIWindow) {
        window.subviews.filter({ $0 is ToastView }).forEach({ toast in
            toast.removeFromSuperview()
        })
    }
}

public class ToastView: UIView {

    private var duration = 2.0

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
