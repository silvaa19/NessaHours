import UIKit
import CoreData

class CalculateHoursViewController: UIViewController {
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var totalHoursLabel: UILabel!
    
    var workEntries: [WorkEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fetchEntriesBetweenDates(startDate: Date, endDate: Date) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<WorkEntry> = WorkEntry.fetchRequest()
        
        // Normalize start and end dates to just date (ignoring time)
        let normalizedStartDate = Calendar.current.startOfDay(for: startDate)
        let normalizedEndDate = Calendar.current.startOfDay(for: endDate)
        
        // Filter based on just the date component (ignoring time)
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", normalizedStartDate as NSDate, normalizedEndDate as NSDate)
        
        do {
            workEntries = try context.fetch(fetchRequest)
            
            // Debug: Check the entries fetched
            for entry in workEntries {
                if let dateIn = entry.dateIn, let dateOut = entry.dateOut {
                    print("Fetched entry: dateIn: \(dateIn), dateOut: \(dateOut)")
                }
            }
        } catch {
            print("Failed to fetch work entries: \(error)")
        }
    }


    
    // Calculate total hours and minutes
    func calculateTotalHours() -> String {
        var totalMinutes: Int = 0
        
        let calendar = Calendar.current
        
        for entry in workEntries {
            if let dateIn = entry.dateIn, let dateOut = entry.dateOut {
                // Calculate time difference in minutes
                let components = calendar.dateComponents([.hour, .minute], from: dateIn, to: dateOut)
                
                let hoursWorked = components.hour ?? 0
                let minutesWorked = components.minute ?? 0
                
                // Convert the hours to minutes and add to totalMinutes
                totalMinutes += (hoursWorked * 60) + minutesWorked
            }
        }
        
        // Convert totalMinutes back to hours and minutes
        let totalHours = totalMinutes / 60
        let remainingMinutes = totalMinutes % 60
        
        // Format the result as "X hours and Y minutes"
        return "\(totalHours) hours and \(remainingMinutes) minutes"
    }
    
    // When the calculate button is pressed
    @IBAction func calculateTotalHoursButtonPressed(_ sender: UIButton) {
        // Get the selected start and end dates
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        
        // Fetch entries between the selected dates
        fetchEntriesBetweenDates(startDate: startDate, endDate: endDate)
        
        // Calculate total hours and minutes
        let totalTime = calculateTotalHours()
        
        // Display the total hours and minutes in the label
        totalHoursLabel.text = "\(totalTime)"
    }
}
