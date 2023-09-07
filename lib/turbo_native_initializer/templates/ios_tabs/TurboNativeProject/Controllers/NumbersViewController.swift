import SwiftUI

class NumbersViewController: UIHostingController<NumbersView> {
    init() {
        super.init(rootView: NumbersView())
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad(); title = "Numbers"
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
