import Foundation
import MicroUICore

enum OwlScreenStrings {

    static var screenTitle: String {
        owlsLocalized("owlscreen.title", comment: "OwlScreen")
    }

    static var detailTitle: String {
        owlsLocalized("owlscreen.detail.title", comment: "Details")
    }

    static var loadingMessage: String {
        owlsLocalized("owlscreen.loading", comment: "Loading owlscreen…")
    }

    static var retryButton: String {
        owlsLocalized("common.retry", comment: "Retry")
    }

    static var closeButton: String {
        owlsLocalized("common.close", comment: "Close")
    }

    static var deleteAction: String {
        owlsLocalized("owlscreen.delete", comment: "Delete")
    }

    static var emptyTitle: String {
        owlsLocalized("owlscreen.empty.title", comment: "No OwlScreen Yet")
    }

    static var emptyDescription: String {
        owlsLocalized("owlscreen.empty.description", comment: "Items will appear here once available.")
    }

    static var tileTitle: String {
        owlsLocalized("owlscreen.tile.title", comment: "OwlScreen")
    }

    static var tileDescription: String {
        owlsLocalized("owlscreen.tile.description", comment: "View OwlScreen")
    }

    static var errorTitle: String {
        owlsLocalized("owlscreen.error.title", comment: "Something went wrong")
    }
}