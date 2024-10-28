//
//  ErrorView.swift
//  FetchRecipeProject
//
//  Created by David Owen on 10/28/24.
//

import SwiftUI

struct ErrorView: View {
    let errorTitle: String
    let errorImage: String
    var errorBody: String? = nil
    var body: some View {
        if #available(iOS 17.0, *) {
            if let errorBody {
                ContentUnavailableView(errorTitle, systemImage: errorImage, description: Text(errorBody))
            } else {
                ContentUnavailableView(errorTitle, systemImage: errorImage)
            }
        } else {
            VStack {
                Image(systemName: errorImage)
                    .resizable()
                    .frame(width: 55, height: 55)
                    .foregroundStyle(Color.secondary)
                Text(errorTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                if let errorBody {
                    Text(errorBody)
                }
            }
        }
    }
}

#Preview {
    ErrorView(errorTitle: "Error loading recipes", errorImage: "exclamationmark.triangle")
}
