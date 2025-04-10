//
//  SoundCategory.swift
//  Roll Strike
//
//  Created by Ehab Saifan on 3/26/25.
//

import Foundation

enum SoundCategory: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case street
    case polite
    case kids
    
    func getSoundFolderName() -> String {
        switch self {
        case .street:
            return "street"
        case .polite:
            return "polite"
        case .kids:
            return "kids"
        }
    }
}
