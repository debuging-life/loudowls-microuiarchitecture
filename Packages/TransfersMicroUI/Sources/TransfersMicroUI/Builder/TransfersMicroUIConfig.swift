import MicroUICore
import Factory

public struct TransfersMicroUIConfig: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.transfersTileBuilder.register {
            TransfersMicroUITileBuilder()
        }
        Container.shared.transfersScreenBuilder.register {
            TransfersMicroUIScreenBuilder()
        }
    }
}
