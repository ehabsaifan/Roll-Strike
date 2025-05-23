//
//  CompStatRow.swift
//  Strike ’Em All
//
//  Created by Ehab Saifan on 5/7/25.
//

import SwiftUI

struct CompStatRow: View {
    let label: String, value1: String, value2: String, emphasize: Bool
    var body: some View {
        HStack {
            Text(value1)
                .bold(emphasize)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(AppTheme.secondaryColor)
                .padding(.leading)
                .multilineTextAlignment(.center)
            Spacer()
            Text(label)
                .font(.caption)
                .bold(emphasize)
                .foregroundStyle(AppTheme.accentColor)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            Spacer()
            Text(value2)
                .bold(emphasize)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundStyle(AppTheme.secondaryColor)
                .padding(.trailing)
                .multilineTextAlignment(.center)
        }
    }
}
