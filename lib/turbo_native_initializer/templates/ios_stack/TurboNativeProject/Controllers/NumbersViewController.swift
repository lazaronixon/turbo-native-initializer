import SwiftUI

class NumbersViewController: UIHostingController<NumbersView> {
    convenience init(title: String) {
        self.init(rootView: NumbersView())
        self.title = title
    }
}

struct NumbersView: View {
    private let numbers = 1 ... 100

    var body: some View {
        List(numbers, id: \.self) { number in
            Text("Row \(number)")
        }
    }
}

struct NumbersView_Preview: PreviewProvider {
    static var previews: some View {
        NumbersView()
    }
}
