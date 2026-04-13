import Foundation
import Kingfisher

// MARK: - Image Cache Config

public enum OwlsImageCache {

    public static func configure(
        memoryLimit: Int = 100 * 1024 * 1024,   // 100 MB
        diskLimit: UInt = 500 * 1024 * 1024,     // 500 MB
        diskExpiration: StorageExpiration = .days(7)
    ) {
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = memoryLimit
        cache.diskStorage.config.sizeLimit = diskLimit
        cache.diskStorage.config.expiration = diskExpiration
    }

    public static func clearAll() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
    }

    public static var diskSize: UInt {
        get async {
            await withCheckedContinuation { continuation in
                ImageCache.default.calculateDiskStorageSize { result in
                    continuation.resume(returning: (try? result.get()) ?? 0)
                }
            }
        }
    }
}
