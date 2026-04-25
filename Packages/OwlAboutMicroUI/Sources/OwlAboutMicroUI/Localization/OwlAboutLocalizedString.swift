import Foundation
import MicroUICore

enum OwlAboutStrings {

    static var screenTitle: String {
        owlsLocalized("owlabout.title", comment: "OwlAbout")
    }

    static var detailTitle: String {
        owlsLocalized("owlabout.detail.title", comment: "Details")
    }

    static var loadingMessage: String {
        owlsLocalized("owlabout.loading", comment: "Loading owlabout…")
    }

    static var retryButton: String {
        owlsLocalized("common.retry", comment: "Retry")
    }

    static var closeButton: String {
        owlsLocalized("common.close", comment: "Close")
    }

    static var deleteAction: String {
        owlsLocalized("owlabout.delete", comment: "Delete")
    }

    static var emptyTitle: String {
        owlsLocalized("owlabout.empty.title", comment: "No OwlAbout Yet")
    }

    static var emptyDescription: String {
        owlsLocalized("owlabout.empty.description", comment: "Items will appear here once available.")
    }

    static var tileTitle: String {
        owlsLocalized("owlabout.tile.title", comment: "OwlAbout")
    }

    static var tileDescription: String {
        owlsLocalized("owlabout.tile.description", comment: "View OwlAbout")
    }

    static var errorTitle: String {
        owlsLocalized("owlabout.error.title", comment: "Something went wrong")
    }
}