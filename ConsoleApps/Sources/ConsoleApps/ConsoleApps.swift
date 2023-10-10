@main
public struct ConsoleApps {
    public private(set) var text = "Hello, World!"

    public static func main() {
        print(ConsoleApps().text)
    }
}
