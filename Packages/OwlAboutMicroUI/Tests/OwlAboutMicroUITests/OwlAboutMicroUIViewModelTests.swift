import Testing
@testable import OwlAboutMicroUI

@Suite("OwlAboutMicroUI ViewModel Tests")
struct OwlAboutMicroUIViewModelTests {

    struct StubOwlAboutRepository: OwlAboutRepository {
        var mockItems: [OwlAboutItem] = OwlAboutItem.mock
        var shouldFail = false

        func loadAll() async throws -> [OwlAboutItem] {
            if shouldFail { throw TestError.mockFailure }
            return mockItems
        }

        func loadDetail(id: String) async throws -> OwlAboutItem {
            guard let item = mockItems.first(where: { $0.id == id }) else {
                throw TestError.mockFailure
            }
            return item
        }

        func create(name: String) async throws -> OwlAboutItem {
            OwlAboutItem(id: UUID().uuidString, title: name, subtitle: "Test", iconName: "star", createdAt: Date())
        }

        func delete(id: String) async throws {
            if shouldFail { throw TestError.mockFailure }
        }
    }

    enum TestError: Error { case mockFailure }

    @Test("Load items successfully")
    func loadItems() async {
        let vm = OwlAboutMicroUIViewModel(repository: StubOwlAboutRepository())
        await vm.load()
        #expect(vm.items.count == 3)
        #expect(vm.isLoading == false)
        #expect(vm.errorMessage == nil)
    }

    @Test("Load items failure shows error")
    func loadItemsFailure() async {
        let vm = OwlAboutMicroUIViewModel(repository: StubOwlAboutRepository(shouldFail: true))
        await vm.load()
        #expect(vm.items.isEmpty)
        #expect(vm.errorMessage != nil)
    }

    @Test("Delete item removes from list")
    func deleteItem() async {
        let vm = OwlAboutMicroUIViewModel(repository: StubOwlAboutRepository())
        await vm.load()
        let firstId = vm.items.first?.id ?? ""
        let countBefore = vm.items.count
        await vm.deleteItem(id: firstId)
        #expect(vm.items.count == countBefore - 1)
    }
}