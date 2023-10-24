//
//  ModelSize.swift
//  Transcriptify
//
//  Created by Jacob Wu on 10/24/23.
//

import Foundation

enum ModelSize: String, CaseIterable {
    case tiny = "ggml-tiny.en"
    case base = "ggml-base.en"
    case small = "ggml-small.en"
    case medium = "ggml-medium.en"
    
    var displayName: String {
        switch self {
        case .base: return "Base"
        case .tiny: return "Tiny"
        case .small: return "Small"
        case .medium: return "Medium"
        }
    }
}
