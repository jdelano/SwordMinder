//
//  Player.swift
//  Player
//
//  Created by John Delano on 10/8/22.
//

import Foundation


/// Represents the Player within the SwordMinder game
struct Player : Codable {
    private(set) var gems: Int = 0
    private var lastRewardReset: Date?
    private var hoursSinceLastRewardsReset: Int? {
        lastRewardReset?.hours(since: Date())
    }
    private var rewardsSinceReset: Int = 0
    private(set) var passages: [Passage]
    private(set) var armor: [Armor]
    private(set) var armorMaterial: ArmorMaterial
    private(set) var reviewedPassages: Dictionary<UUID, [Date]> = [:]

    /// The player's level calculated by the average level of each armor piece, taking into account the material of each armor set
    var level: Int {
        var sum = 0
        armor.forEach { sum += $0.level }
        return sum / 4 + (armorMaterial.rawValue * PlayerConstants.maxLevel)
    }
    
    /// Represents the asset name of the corresponding armor in the game
    var imageName: String {
        var materialName = "";
        switch armorMaterial {
            case .linen: materialName = "linen"
            case .leather: materialName = "leather"
            case .damascusSteel: materialName = "damascusSteel"
            case .gem: materialName = "gem"
        }
        return materialName + "Body"
    }

    /// Determines whether the player is able to receive a reward from completing a task
    ///
    /// Players who are ineligible and still complete a task will receive no gems.
    /// Players are considered eligible to receive a reward if they have earned fewer than 5 rewards in the past 24 hours.
    var eligible: Bool {
        if let hoursSinceLastRewardReset = hoursSinceLastRewardsReset {
            if hoursSinceLastRewardReset >= 24 || (hoursSinceLastRewardReset < 24 && rewardsSinceReset < 5) {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }

    
    /// Identifies the different types of armor that a Player can wear. The armor pieces that a player wears must all come from the same set (i.e., the same material)
    /// The raw value assigned to each case is a multiplier used in determining the overall player level.
    enum ArmorMaterial: Int, Codable {
        case linen = 0
        case leather = 1
        case damascusSteel = 2
        case gem = 3
    }

    /// Initializer that creates a new Player with specified armor array and gem count.
    ///
    /// If the armor array contains fewer than four pieces, the initializer will fill in the remaining pieces at level 1.
    /// If the armor array contains duplicate armor pieces, the initializer will only use the first armor of each piece type.
    ///
    /// - Parameters:
    ///   - armor: An array containing up to four armor pieces.
    ///   - gems: The count of gems that the player has
    ///   - passages: An array of Bible passages that the player has selected for their passage list
    init(withArmor armor: [Armor] = [], armorMaterial: ArmorMaterial = .linen, gems: Int = 0, passages: [Passage] = []) {
        self.armor = []
        // Use only the first of each armor piece; if piece not present, use default armor for that piece
        if let helmet = armor.first(where: { $0.piece == .helmet }) {
            self.armor.append(helmet)
        } else {
            self.armor.append(Armor(piece: .helmet))
        }
        if let breastplate = armor.first(where: { $0.piece == .breastplate }) {
            self.armor.append(breastplate)
        } else {
            self.armor.append(Armor(piece: .breastplate))
        }
        if let belt = armor.first(where: { $0.piece == .belt }) {
            self.armor.append(belt)
        } else {
            self.armor.append(Armor(piece: .belt))
        }
        if let shoes = armor.first(where: { $0.piece == .shoes }) {
            self.armor.append(shoes)
        } else {
            self.armor.append(Armor(piece: .shoes))
        }
        self.armorMaterial = armorMaterial
        self.gems = gems
        self.passages = passages
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

    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case gems
        case lastRewardReset
        case rewardsSinceReset
        case passages
        case armor
        case armorMaterial
        case reviewedPassages
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gems = try container.decode(Int.self, forKey: .gems)
        self.lastRewardReset = try container.decodeIfPresent(Date.self, forKey: .lastRewardReset)
        self.rewardsSinceReset = try container.decodeIfPresent(Int.self, forKey: .rewardsSinceReset) ?? 0
        self.passages = try container.decode([Passage].self, forKey: .passages)
        self.armor = try container.decode([Player.Armor].self, forKey: .armor)
        self.armorMaterial = try container.decode(Player.ArmorMaterial.self, forKey: .armorMaterial)
        self.reviewedPassages = try container.decodeIfPresent(Dictionary<UUID, [Date]>.self, forKey: .reviewedPassages) ?? [:]
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(gems, forKey: .gems)
        try container.encode(lastRewardReset, forKey: .lastRewardReset)
        try container.encode(passages, forKey: .passages)
        try container.encode(armor, forKey: .armor)
        try container.encode(armorMaterial, forKey: .armorMaterial)
        try container.encode(reviewedPassages, forKey: .reviewedPassages)
    }
        
//    func costToLevelUp(for piece: Armor.ArmorPiece) -> Int {
//        armor.filter( { $0.piece == piece }).first?.costToLevelUp() ?? 9999
//    }
    
    var canUpgradeArmorMaterial: Bool {
        // Can only upgrade armor when all pieces are at max level and when the player has not already reached the highest armor material
        armor.allSatisfy({ $0.level == PlayerConstants.maxLevel }) && armorMaterial != .gem
    }
    
    /// Upgrade current armor set to next highest material type
    ///
    /// Armor can only be upgraded if all armor pieces are at max level
    /// Calling upgradeArmor when even one armor piece is less than max level will do nothing
    /// When all armor pieces are at max level when upgradeArmor is called, the armorMaterial of the Player is changed to the next highest material type (based on raw value), and each armor piece is reset to level 1.
    mutating func upgradeArmor() {
        if canUpgradeArmorMaterial {
            self.armorMaterial = ArmorMaterial(rawValue: self.armorMaterial.rawValue + 1) ?? .gem
            // Reset each armor piece back to level 1
            armor.indices.forEach({ armor[$0].reset() })
            print(self.armorMaterial)
        }
    }
    
    
    /// Reward the player by giving them the specified number of gems
    ///
    /// Rewards can only be between 1 and 5 gems.
    /// Players must wait 24 hours after earning 5 rewards
    ///
    /// - Parameter gems: The number of gems to give the player
    mutating func reward(gems: Int) {
        // Only allow rewards of between 1 and 5 gems at a time
        if gems >= 1 && gems <= 5 && eligible {
            // See if last reward was earned
            self.gems += gems
            
            // < 24 hours and < 5 rewards, then just add 1 to rewards
            // no reset, then set reset and set rewards = 1
            if let hoursSinceLastRewardsReset = hoursSinceLastRewardsReset,
               hoursSinceLastRewardsReset < 24,
               rewardsSinceReset < 5 {
                rewardsSinceReset += 1
            } else {
                lastRewardReset = Date()
                rewardsSinceReset = 1
            }
        }
    }

    
    /// Determines whether or not a specified piece of armor can be leveled up
    /// - Parameter piece: Armor piece to level up
    /// - Returns: Whether or not the player has sufficient gems to level up the armor piece and/or whether or not the armor piece is still below max level
    func canLevelUp(armorPiece piece: Armor.ArmorPiece) -> Bool {
        guard let armorIndex = index(forPiece: piece) else {
            return false
        }
        let levelUpCost = armor[armorIndex].costToLevelUp()
        return levelUpCost <= self.gems && armor[armorIndex].level < PlayerConstants.maxLevel
    }
    
    
    /// Level's up the specified armor piece if the player has the resources and if the armor piece is eligible to be leveled up
    /// - Parameter piece: The armor piece to level up
    mutating func levelUp(piece: Armor.ArmorPiece) {
        guard let armorIndex = index(forPiece: piece) else {
            return
        }
        let levelUpCost = armor[armorIndex].costToLevelUp()
        if canLevelUp(armorPiece: piece) {
            armor[armorIndex].levelUp()
            gems -= levelUpCost
        }
    }
    
    
    mutating func charge(gems: Int) {
        // Don't allow spending more than the player has
        if self.gems > gems {
            self.gems -= gems
        }
    }
    
    /// Retrieves the index value of the requested armor piece
    /// - Parameter piece: The armor piece to lookup
    /// - Returns: The index position of the specified armor piece; returns nil if armor piece is not found
    private func index(forPiece piece: Armor.ArmorPiece) -> Int? {
        self.armor.firstIndex(where: { $0.piece == piece })
    }
    
    
    // MARK: - Passages
    
    /// Adds a `Passage` to the player's list of selected Bible passages for memorization
    /// - Parameter passage: The `Passage` object to add to the player's list of selected passages
    mutating func addPassage(_ passage: Passage) {
        passages.append(passage)
    }
    
        
    /// Removes the `Passage` objects from the player's list of selected passages at the specified offsets
    /// - Parameter offsets: The index offsets corresponding to the selected passages to remove
    mutating func removePassages(atOffsets offsets: IndexSet) {
        passages.remove(atOffsets: offsets)
    }

    
    mutating func reviewPassage(_ passage: Passage) {
        if reviewedPassages[passage.id] != nil {
            reviewedPassages[passage.id]!.append(Date())
        } else {
            reviewedPassages[passage.id] = [Date()]
        }
    }
    
    /// Indicates whether or not the player has reviewed the specified passage at least the minimum number of times today
    /// - Parameter passage: The `Passage` being reviewed
    /// - Returns: A `Bool` indicating whether or not the player has reviewed the passage the minimum number of times today.
    func passageReviewedToday(_ passage: Passage) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return (reviewedPassages[passage.id]?.filter( { $0 > today}).count ?? 0) >= PlayerConstants.minReviewsPerDay
    }
    
    // MARK: - Armor
    struct Armor: Identifiable, Codable {
        var id = UUID()
        private(set) var level: Int = 1
        private(set) var charged = false
        private(set) var piece: ArmorPiece
        var imageName: String {
            switch piece {
                case .helmet: return "brain.head.profile"
                case .breastplate: return "heart.fill"
                case .belt: return "figure.walk"
                case .shoes: return "shoeprints.fill"
            }
        }
                
        enum ArmorPiece: String, Codable {
            case helmet = "helmet"
            case breastplate = "breastplate"
            case belt = "belt"
            case shoes = "shoes"
        }
        
        func costToLevelUp() -> Int {
            let nextLevel = Double(level + 1)
            let numerator = PlayerConstants.levelUpFactor * (pow(PlayerConstants.baseLevelUp, nextLevel) + nextLevel)
            let denominator = PlayerConstants.levelInfationFactor * nextLevel + PlayerConstants.levelDampening
            return Int((numerator / denominator))
        }
        
        mutating fileprivate func levelUp() {
            if (level < PlayerConstants.maxLevel) {
                level += 1
            }
        }
        
        mutating fileprivate func reset() {
            level = 1
        }
    }
    
    // MARK: - PlayerConstants
    struct PlayerConstants : Codable {
        // Larger numbers increase difficulty early; lower numbers flattens the growth curve
        static let levelUpFactor: Double = 3.0
        // Even small increases dramatically increase cost of leveling up
        static let baseLevelUp: Double = 1.15
        // Smaller numbers increases inflation
        static let levelInfationFactor: Double = 0.5
        // Larger numbers shifts the curve downard
        static let levelDampening: Double = 2.0
        static let maxLevel: Int = 40
        static let minReviewsPerDay: Int = 3
    }
    
    
    
}
