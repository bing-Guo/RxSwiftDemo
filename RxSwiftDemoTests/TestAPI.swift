import Foundation
import RxSwift
@testable import RxSwiftDemo

class TestAPI: ProductAPIProtocol {
    func request(page: Int) -> Single<[Product]> {
        .create { (single) -> Disposable in
            DispatchQueue.global().async {
                sleep(2)

                DispatchQueue.main.async {
                    var data: [Product] = []

                    if page == 1 {
                        data = [
                            Product(name: "Test 1", price: 100, images: ["A"]),
                            Product(name: "Test 2", price: 200, images: ["A"]),
                            Product(name: "Test 3", price: 300, images: ["A"]),
                            Product(name: "Test 4", price: 400, images: ["A"]),
                            Product(name: "Test 5", price: 500, images: ["A"]),
                            Product(name: "Test 6", price: 600, images: ["B"]),
                            Product(name: "Test 7", price: 700, images: ["B"]),
                            Product(name: "Test 8", price: 800, images: ["B"]),
                            Product(name: "Test 9", price: 900, images: ["B"]),
                            Product(name: "Test 10", price: 1000, images: ["B"]),
                            Product(name: "Test 11", price: 1100, images: ["C"]),
                            Product(name: "Test 12", price: 1200, images: ["C"]),
                            Product(name: "Test 13", price: 1300, images: ["C"]),
                            Product(name: "Test 14", price: 1400, images: ["C"]),
                            Product(name: "Test 15", price: 1500, images: ["C"]),
                            Product(name: "Test 16", price: 1500, images: ["D"]),
                            Product(name: "Test 17", price: 1500, images: ["D"]),
                            Product(name: "Test 18", price: 1500, images: ["D"]),
                            Product(name: "Test 19", price: 1500, images: ["D"]),
                            Product(name: "Test 20", price: 1500, images: ["D"]),
                        ]
                    }

                    if page == 2 {
                        data = [
                            Product(name: "Test 21", price: 1100, images: ["E"])
                        ]
                    }

                    print("Page: \(page)")

                    single(.success(data))
                }
            }

            return Disposables.create()
        }
    }
}
