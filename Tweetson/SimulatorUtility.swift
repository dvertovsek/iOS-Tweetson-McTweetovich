import Foundation

class SimulatorUtility
{
    class var isRunningSimulator: Bool
    {
        get
        {
            return TARGET_OS_SIMULATOR != 0
        }
    }
}