import Foundation
import RxCocoa
import RxSwift

enum ProductAPIError: Error {
    case unknow
}

protocol ProductAPIProtocol {
    func request(page: Int) -> Single<[Product]>
}

class ProductAPI: ProductAPIProtocol {
    func request(page: Int) -> Single<[Product]> {
        .create { (single) -> Disposable in
            DispatchQueue.global().async {
                sleep(2)

                DispatchQueue.main.async {
                    let data = ProductModelManager.instance.getProducts()

                    single(.success(data))
                }
            }

            return Disposables.create()
        }
    }
}

class ProductModelManager {

    private init() {}

    static let instance = ProductModelManager()

    private let per = 20

    private let imageData = ["A", "B", "C", "D", "E"]

    func getProducts() -> [Product] {
        var products: [Product] = []

        for _ in 0..<per {
            products.append(generateRandomProduct())
        }

        return products
    }

    private func generateRandomProduct() -> Product {
        let randomIndex = Int.random(in: 0..<imageData.count)

        return Product(name: imageData[randomIndex],
                       price: Int.random(in: 100...10000),
                       images: [imageData[randomIndex]])
    }
}
