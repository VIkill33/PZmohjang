//
//  Player.swift
//  PZmohjang
//
//  Created by Vikill Blacks on 2023/2/17.
//

import SwiftUI

class Player: ObservableObject {
    @Published var score: Int = 0
    @Published var hu: Int = 0
    @Published var yao: Int = 0
    @Published var isHost: Bool = false
    @Published var isWin: Bool = false
    @Published var isPiaohun: Bool = false
    @Published var type: player_type
    @Published var id = UUID()
    init(type: player_type) {
        self.type = type
    }
    func reset() {
        score = 0
        hu = 0
        yao = 0
        isHost = false
        isWin = false
        isPiaohun = false
    }
}

public enum player_type {
    case north
    case south
    case east
    case west
    public func player_type2String() -> String {
        switch self {
        case .south:
            return "南"
        case .north:
            return "北"
        case .west:
            return "西"
        case .east:
            return "东"
        }
    }
}
