import Foundation

class Product {
    let name: String
    let price: Int
    let images: [String]
    
    init(name: String, price: Int, images: [String]) {
        self.name = name
        self.price = price
        self.images = images
    }
}
