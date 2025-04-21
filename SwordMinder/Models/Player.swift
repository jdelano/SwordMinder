import Foundation

struct Player: Codable, Identifiable {
    typealias ArmorPiece = Armor.ArmorPiece
    typealias ArmorMaterial = Armor.ArmorMaterial
    
    var id = UUID()
    
    // MARK: - Player State
    private(set) var gems: Int = 0
    private var lastRewardReset: Date?
    private var rewardsSinceReset: Int = 0
    private(set) var passages: [Passage]
    private(set) var armor: [Armor]
    private(set) var reviewedPassages: [UUID: [Date]] = [:]
    var preferredVersion: Translation
    
    // MARK: - Computed Properties
    private var hoursSinceLastRewardsReset: Int? {
        lastRewardReset?.hours(since: Date())
    }
    
    var level: Int {
        let materialValueTotal = armor.reduce(0) { $0 + $1.material.value }
        let materialScore = materialValueTotal / armor.count * Constants.maxLevel
        let levelScore = armor.reduce(0) { $0 + $1.level }
        return materialScore + levelScore
    }
    
    var characterAssetName: String {
        guard let lowestMaterial = armor.min(by: { $0.material < $1.material })?.material else {
            return "peasant_character"
        }
        
        switch lowestMaterial {
            case .linen:
                return "peasant_character"
            case .leather:
                return "linen_character"
            case .damascusSteel:
                return "leather_character"
            case .gem:
                let allMaxLevel = armor.allSatisfy { $0.level == Constants.maxLevel }
                return allMaxLevel ? "gem_character" : "damascus_character"
        }
    }
    
    var eligible: Bool {
        guard let hours = hoursSinceLastRewardsReset else { return true }
        return hours >= 24 || rewardsSinceReset < 5
    }
    
    
    // MARK: - Initialization
    init(withArmor armor: [Armor] = [], gems: Int = 0, passages: [Passage] = [], version: Translation = .esv) {
        if armor.isEmpty {
            self.armor = ArmorPiece.allCases.map { Armor(piece: $0) }
        } else {
            self.armor = armor
        }
        self.gems = gems
        self.passages = passages
        self.preferredVersion = version
    }
    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case gems, lastRewardReset, rewardsSinceReset, passages, armor, armorMaterial, reviewedPassages, preferredVersion
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gems = try container.decode(Int.self, forKey: .gems)
        self.lastRewardReset = try container.decodeIfPresent(Date.self, forKey: .lastRewardReset)
        self.rewardsSinceReset = try container.decodeIfPresent(Int.self, forKey: .rewardsSinceReset) ?? 0
        self.passages = try container.decode([Passage].self, forKey: .passages)
        self.armor = try container.decode([Armor].self, forKey: .armor)
        self.reviewedPassages = try container.decodeIfPresent([UUID: [Date]].self, forKey: .reviewedPassages) ?? [:]
        self.preferredVersion = try container.decodeIfPresent(Translation.self, forKey: .preferredVersion) ?? .esv
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(gems, forKey: .gems)
        try container.encode(lastRewardReset, forKey: .lastRewardReset)
        try container.encode(passages, forKey: .passages)
        try container.encode(armor, forKey: .armor)
        try container.encode(reviewedPassages, forKey: .reviewedPassages)
        try container.encode(preferredVersion, forKey: .preferredVersion)
    }
    
    func json() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
    init(json: Data) throws {
        self = try JSONDecoder().decode(Player.self, from: json)
    }
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try Player(json: data)
    }
    
    // MARK: - Armor Management
    
    /// Retrieves the index value of the requested armor piece
    /// - Parameter piece: The armor piece to lookup
    /// - Returns: The index position of the specified armor piece; returns nil if armor piece is not found
    private func index(piece: ArmorPiece) -> Int? {
        armor.firstIndex(where: { $0.piece == piece })
    }
    
    func canLevelUp(piece: ArmorPiece) -> Bool {
        guard let i = index(piece: piece) else { return false }
        let a = armor[i]
        return a.costToLevelUp() <= gems && a.level < Constants.maxLevel
    }
    
    mutating func levelUp(piece: ArmorPiece) {
        guard let i = index(piece: piece), canLevelUp(piece: piece) else { return }
        gems -= armor[i].costToLevelUp()
        var upgraded = armor[i]
        upgraded.levelUp()
        armor[i].levelUp() // = upgraded
    }
    
    func canUpgrade(piece: ArmorPiece) -> Bool {
        guard let i = index(piece: piece) else { return false }
        return armor[i].level == Constants.maxLevel && armor[i].material < .gem
    }
    
    mutating func upgrade(piece: ArmorPiece) {
        guard let i = index(piece: piece), canUpgrade(piece: piece) else { return }
        armor[i].material = armor[i].material.next
        armor[i].reset()
    }
    
    // MARK: - Currency Management
    
    mutating func charge(gems: Int) {
        if self.gems > gems { self.gems -= gems }
    }
    
    // MARK: - Reward Logic
    mutating func reward(gems: Int) {
        guard (1...5).contains(gems), eligible else { return }
        self.gems += gems
        if let hours = hoursSinceLastRewardsReset, hours < 24, rewardsSinceReset < 5 {
            rewardsSinceReset += 1
        } else {
            lastRewardReset = Date()
            rewardsSinceReset = 1
        }
    }
    
    // MARK: - Passage Management
    mutating func addPassage(_ passage: Passage) {
        passages.append(passage)
    }
    
    mutating func removePassages(atOffsets offsets: IndexSet) {
        passages.remove(atOffsets: offsets)
    }
    
    mutating func reviewPassage(_ passage: Passage) {
        reviewedPassages[passage.id, default: []].append(Date())
    }
    
    func passageReviewedToday(_ passage: Passage) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return (reviewedPassages[passage.id]?.filter { $0 > today }.count ?? 0) >= Constants.minReviewsPerDay
    }
    
    // MARK: - Armor Types
    struct Armor: Identifiable, Codable {
        var id = UUID()
        private(set) var level: Int = 1
        private(set) var charged = false
        private(set) var piece: ArmorPiece
        fileprivate(set) var material: ArmorMaterial = .linen
        
        
        var description: String {
            switch piece {
                case .helmet: "Helmet of Salvation"
                case .breastplate: "Breastplate of Righteousness"
                case .belt: "Belt of Truth"
                case .shoes: "Shoes of Peace"
            }
        }
        
        var assetName: String {
            "\(material.rawValue)_\(piece.rawValue)"
        }
        
        func costToLevelUp() -> Int {
            guard level < Constants.maxLevel else { return 0 }
            let next = Double(level + 1)
            let top = Constants.levelUpFactor * (pow(Constants.baseLevelUp, next) + next)
            let bottom = Constants.levelInfationFactor * next + Constants.levelDampening
            return Int(top / bottom)
        }
        
        fileprivate mutating func levelUp() {
            guard level < Constants.maxLevel else { return }
            level += 1
        }
        
        fileprivate mutating func reset() {
            level = 1
        }
        
        enum ArmorMaterial: String, Codable, Comparable {
            static func < (lhs: Player.Armor.ArmorMaterial, rhs: Player.Armor.ArmorMaterial) -> Bool {
                lhs.value < rhs.value
            }
            
            case linen = "linen", leather = "leather", damascusSteel = "damascus", gem = "gem"
            
            var next: ArmorMaterial {
                switch self {
                    case .linen: .leather
                    case .leather: .damascusSteel
                    case .damascusSteel: .gem
                    case .gem: .gem
                }
            }
            
            var value: Int {
                switch self {
                    case .linen: 1
                    case .leather: 2
                    case .damascusSteel: 3
                    case .gem: 4
                }
            }
        }
        
        enum ArmorPiece: String, Codable, CaseIterable {
            case helmet = "helmet", breastplate = "chest", belt = "pants", shoes = "boots"
        }
    }
    
    // MARK: - Constants
    struct Constants {
        static let levelUpFactor: Double = 3.0
        static let baseLevelUp: Double = 1.15
        static let levelInfationFactor: Double = 0.5
        static let levelDampening: Double = 2.0
        static let maxLevel: Int = 40
        static let minReviewsPerDay: Int = 3
    }
}
