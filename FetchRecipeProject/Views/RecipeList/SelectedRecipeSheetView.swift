//
//  SelectedRecipeSheetView.swift
//  FetchRecipeProject
//
//  Created by David Owen on 10/28/24.
//

import SwiftUI
import Kingfisher
import YouTubePlayerKit

struct SelectedRecipeSheetView: View {
    let recipe: Recipe
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(recipe.name)
                        .font(.title3)
                    Text(recipe.cuisine)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()

                KFImage(URL(string: recipe.photoUrlSmall ?? ""))
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .frame(width: 75, height: 75)
                    .clipShape(.rect(cornerRadius: 10))
            }
            .padding()

            if let youtubeUrl = recipe.youtubeUrl {
                let youTubePlayer: YouTubePlayer = YouTubePlayer(stringLiteral: youtubeUrl)

                YouTubePlayerView(youTubePlayer) { state in
                    switch state {
                    case .idle:
                        ProgressView()
                    case .ready:
                        EmptyView()
                    case .error(_):
                        KFImage(URL(string: recipe.photoUrlLarge ?? ""))
                            .placeholder {
                                ProgressView()
                            }
                            .resizable()
                            .clipShape(.rect(cornerRadius: 10))
                    }
                }
                .padding()
            }

            if let sourceUrl = recipe.sourceUrl, let url = URL(string: sourceUrl) {
                Link("View Source", destination: url)
            }
        }
    }
}

#Preview {
    SelectedRecipeSheetView(recipe: Recipe(
        id: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
        cuisine: "Malaysian",
        name: "Apam Balik",
        photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
        photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
        sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
        youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg"))
}
