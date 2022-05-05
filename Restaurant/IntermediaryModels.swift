import Foundation

struct Categories: Codable {
    let categories: [String]
}

struct PreparationTime: Codable {
    let preparationTime: Int
    
    enum CodingKeys: String, CodingKey { // When a DecodingContainer isn't used, the name CodingKeys is mandatory. Can't change it, otherwise Swift won't function properly !!
        case preparationTime = "preparation_time"
    }
}

struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
