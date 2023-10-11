import Foundation

struct TurboNativeProject {
    private static let developmentURL = URL(string: "http://localhost:3000")!
    private static let productionURL  = URL(string: "https://turbo-native-demo.glitch.me")!

    static var baseURL:   URL { productionURL }
    static var homeURL1:  URL { baseURL.appendingPathComponent("/") }
    static var homeURL2:  URL { baseURL.appendingPathComponent("/") }
}
