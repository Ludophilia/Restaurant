import Foundation

struct MenuItem: Codable {
    var id: Int
    var name: String
    var category: String
    var itemDescription: String
    var price: Double
    var imageURL: URL
    
    enum CodingKeys: String, CodingKey { // When a DecodingContainer isn't used, the name CodingKeys is mandatory. Can't change it, otherwise Swift won't function properly !!
        case id
        case name
        case category
        case itemDescription = "description"
        case price
        case imageURL = "image_url"
    }
}

struct MenuItems: Codable {
    let items: [MenuItem]
}
