//
//  AppIconOptions.swift
//  Ignited
//
//  Created by Chris Rittenhouse on 5/2/23.
//  Copyright © 2023 LitRitt. All rights reserved.
//

import SwiftUI

import Features

enum AppIcon: String, CaseIterable, CustomStringConvertible, Identifiable
{
    case normal = "Default"
    case neon = "Neon"
    case classic = "Classic"
    case simple = "Simple"
    case glass = "Glass"
    case ablaze = "Ablaze"
    
    var description: String {
        return self.rawValue
    }
    
    var id: String {
        return self.rawValue
    }
    
    var author: String {
        switch self
        {
        case .normal, .neon: return "LitRitt"
        case .classic: return "Kongolabongo"
        case .simple, .glass: return "epicpal"
        case .ablaze: return "Salty"
        }
    }
    
    var assetName: String {
        switch self
        {
        case .normal: return "IconOrange"
        case .neon: return "IconNeon"
        case .classic: return "IconClassic"
        case .simple: return "IconSimple"
        case .glass: return "IconGlass"
        case .ablaze: return "IconAblaze"
        }
    }
}

extension AppIcon: LocalizedOptionValue
{
    var localizedDescription: Text {
        Text(self.description)
    }
}

extension AppIcon: Equatable
{
    static func == (lhs: AppIcon, rhs: AppIcon) -> Bool
    {
        return lhs.description == rhs.description
    }
}

struct AppIconOptions
{
    @Option(name: "Alternate App Icon",
            description: "Choose from alternate app icons created by the community.",
            detailView: { value in
        List {
            ForEach(AppIcon.allCases) { icon in
                HStack {
                    if icon == value.wrappedValue {
                        Text("✓")
                            .foregroundColor(.accentColor)
                        icon.localizedDescription
                            .foregroundColor(.accentColor)
                    } else {
                        icon.localizedDescription
                    }
                    Text("- by \(icon.author)")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                    Spacer()
                    Image(uiImage: Bundle.appIcon(icon) ?? UIImage())
                        .cornerRadius(13)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    value.wrappedValue = icon
                }
            }
        }
        .onChange(of: value.wrappedValue) { _ in
            updateAppIcon()
        }
        .displayInline()
    })
    var alternateIcon: AppIcon = .normal
    
    @Option(name: "Restore Defaults",
            description: "Reset all options to their default values.",
            detailView: { _ in
        Button("Restore Defaults") {
            PowerUserOptions.resetFeature(.appIcon)
        }
        .font(.system(size: 17, weight: .bold, design: .default))
        .foregroundColor(.red)
        .displayInline()
    })
    var reset: Bool = false
}

extension AppIconOptions
{
    static func updateAppIcon()
    {
        let currentIcon = UIApplication.shared.alternateIconName
        let altIcon = Settings.userInterfaceFeatures.appIcon.alternateIcon
        
        switch altIcon
        {
        case .normal: if currentIcon != nil { UIApplication.shared.setAlternateIconName(nil) }
        default: if currentIcon != altIcon.assetName { UIApplication.shared.setAlternateIconName(altIcon.assetName) }
        }
    }
}