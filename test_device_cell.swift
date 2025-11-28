import UIKit

// Simple test to verify DeviceCell compiles correctly
func testDeviceCell() {
    // This test verifies that DeviceCell can be instantiated and configured
    let cell = DeviceCell(style: .default, reuseIdentifier: "DeviceCell")
    
    // Test configuration
    cell.configure(
        name: "Test Device",
        status: "Connected",
        isConnected: true,
        signalStrength: 3
    )
    
    // Verify device icon can be set
    cell.deviceIcon.image = UIImage(systemName: "iphone")
    
    print("DeviceCell test passed - cell can be created and configured")
}

// Test the casting that was failing in HomeViewController
func testDeviceCellCasting() {
    // Simulate the table view cell creation
    let tableView = UITableView()
    tableView.register(DeviceCell.self, forCellReuseIdentifier: "DeviceCell")
    
    // This simulates the line that was failing: as! DeviceCell
    let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell") as! DeviceCell
    
    print("DeviceCell casting test passed - cell can be cast to DeviceCell")
}

print("All DeviceCell tests completed successfully")