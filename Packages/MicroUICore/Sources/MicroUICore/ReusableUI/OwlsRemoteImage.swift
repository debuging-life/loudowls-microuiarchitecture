import SwiftUI
import Kingfisher

// MARK: - Remote Image (Kingfisher wrapper)

public struct OwlsRemoteImage: View {

    private let url: URL?
    private let placeholder: String
    private let size: CGSize?

    public init(url: URL?, placeholder: String = "photo", size: CGSize? = nil) {
        self.url = url
        self.placeholder = placeholder
        self.size = size
    }

    public init(urlString: String?, placeholder: String = "photo", size: CGSize? = nil) {
        self.url = urlString.flatMap { URL(string: $0) }
        self.placeholder = placeholder
        self.size = size
    }

    public var body: some View {
        KFImage(url)
            .placeholder {
                Image(systemName: placeholder)
                    .font(.title)
                    .foregroundStyle(OwlsColor.secondaryLabel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(OwlsColor.secondaryBackground)
            }
            .retry(maxCount: 2, interval: .seconds(2))
            .cacheMemoryOnly(false)
            .fade(duration: 0.3)
            .resizable()
            .scaledToFill()
            .applySize(size)
    }
}

// MARK: - Size Modifier

extension View {
    @ViewBuilder
    fileprivate func applySize(_ size: CGSize?) -> some View {
        if let size {
            self.frame(width: size.width, height: size.height).clipped()
        } else {
            self
        }
    }
}

// MARK: - Re-export Kingfisher for modules

@_exported import Kingfisher
