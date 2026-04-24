import Testing
@testable import FavoriteScreenMicroUI

@Suite("FavoriteScreenMicroUI ViewModel Tests")
struct FavoriteScreenMicroUIViewModelTests {

    struct StubFavoriteScreenRepository: FavoriteScreenRepository {
        var mockItems: [FavoriteScreenItem] = FavoriteScreenItem.mock
        var shouldFail = false

        func loadAll() async throws -> [FavoriteScreenItem] {
            if shouldFail { throw TestError.mockFailure }
            return mockItems
        }

        func loadDetail(id: String) async throws -> FavoriteScreenItem {
            guard let item = mockItems.first(where: { $0.id == id }) else {
                throw TestError.mockFailure
            }
            return item
        }

        func create(name: String) async throws -> FavoriteScreenItem {
            FavoriteScreenItem(id: UUID().uuidString, title: name, subtitle: "Test", iconName: "star", createdAt: Date())
        }

        func delete(id: String) async throws {
            if shouldFail { throw TestError.mockFailure }
        }
    }

    enum TestError: Error { case mockFailure }

    @Test("Load items successfully")
    func loadItems() async {
        let vm = FavoriteScreenMicroUIViewModel(repository: StubFavoriteScreenRepository())
        await vm.load()
        #expect(vm.items.count == 3)
        #expect(vm.isLoading == false)
        #expect(vm.errorMessage == nil)
    }

    @Test("Load items failure shows error")
    func loadItemsFailure() async {
        let vm = FavoriteScreenMicroUIViewModel(repository: StubFavoriteScreenRepository(shouldFail: true))
        await vm.load()
        #expect(vm.items.isEmpty)
        #expect(vm.errorMessage != nil)
    }

    @Test("Delete item removes from list")
    func deleteItem() async {
        let vm = FavoriteScreenMicroUIViewModel(repository: StubFavoriteScreenRepository())
        await vm.load()
        let firstId = vm.items.first?.id ?? ""
        let countBefore = vm.items.count
        await vm.deleteItem(id: firstId)
        #expect(vm.items.count == countBefore - 1)
    }
}