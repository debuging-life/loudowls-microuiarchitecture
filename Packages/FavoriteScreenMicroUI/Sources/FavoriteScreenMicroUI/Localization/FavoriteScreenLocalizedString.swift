import Foundation
import MicroUICore

enum FavoriteScreenStrings {

    static var screenTitle: String {
        owlsLocalized("favoritescreen.title", comment: "FavoriteScreen")
    }

    static var detailTitle: String {
        owlsLocalized("favoritescreen.detail.title", comment: "Details")
    }

    static var loadingMessage: String {
        owlsLocalized("favoritescreen.loading", comment: "Loading favoritescreen…")
    }

    static var retryButton: String {
        owlsLocalized("common.retry", comment: "Retry")
    }

    static var closeButton: String {
        owlsLocalized("common.close", comment: "Close")
    }

    static var deleteAction: String {
        owlsLocalized("favoritescreen.delete", comment: "Delete")
    }

    static var emptyTitle: String {
        owlsLocalized("favoritescreen.empty.title", comment: "No FavoriteScreen Yet")
    }

    static var emptyDescription: String {
        owlsLocalized("favoritescreen.empty.description", comment: "Items will appear here once available.")
    }

    static var tileTitle: String {
        owlsLocalized("favoritescreen.tile.title", comment: "FavoriteScreen")
    }

    static var tileDescription: String {
        owlsLocalized("favoritescreen.tile.description", comment: "View FavoriteScreen")
    }

    static var errorTitle: String {
        owlsLocalized("favoritescreen.error.title", comment: "Something went wrong")
    }
}