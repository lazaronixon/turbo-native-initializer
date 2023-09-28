import SwiftUI

public extension UIViewController {
    func presentToast(_ message: String) {
        guard let root = view.window?.rootViewController else { return }

        let toastView = ToastView(message: message)
        toastView.translatesAutoresizingMaskIntoConstraints = false

        root.view.addSubview(toastView)

        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: root.view.centerXAnchor),
            toastView.topAnchor.constraint(equalTo: root.view.safeAreaLayoutGuide.topAnchor),
            toastView.widthAnchor.constraint(equalTo: root.view.safeAreaLayoutGuide.widthAnchor, constant: -10)
        ])
    }
}

public class ToastView: UIView {
    convenience init(message: String) {
        self.init(frame: .zero)
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

        self.alpha = .zero

        UIView.animate(withDuration: 0.5, delay: .zero, animations: {
            self.alpha = 0.9
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { self.dismiss() }
        })
    }

    @objc func dismiss() {
        UIView.animate(withDuration: 0.5, delay: .zero, animations: {
            self.alpha = .zero
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
