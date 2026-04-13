import MicroUICore
import Factory

public struct AuthMicroUIConfig: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.authScreenBuilder.register {
            AuthMicroUIScreenBuilder()
        }
    }
}
