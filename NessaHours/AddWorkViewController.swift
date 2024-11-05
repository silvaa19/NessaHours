import UIKit
import CoreData

class AddWorkViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var officePicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateInPicker: UIDatePicker!
    @IBOutlet weak var dateOutPicker: UIDatePicker!
    
    let officeList = ["Bronx", "212A", "308B", "PalmerRd"]
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set picker view delegate and data source
            officePicker.delegate = self
            officePicker.dataSource = self
        }
        
        // MARK: - UIPickerViewDataSource Methods
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1 // One column for the office list
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return officeList.count // Number of rows is the number of offices
        }
        
        // MARK: - UIPickerViewDelegate Method
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return officeList[row] // Return the office name for each row
        }
        
        // MARK: - Save Work Entry
        @IBAction func saveWorkEntry(_ sender: UIButton) {
            let selectedOfficeIndex = officePicker.selectedRow(inComponent: 0)
            let office = officeList[selectedOfficeIndex]
            let date = datePicker.date
            let timeIn = dateInPicker.date
            let timeOut = dateOutPicker.date

            // Check if the date already exists
            if isDateAlreadyUsed(date: date) {
                showErrorMessage()
                return // Stop the saving process
            }
            
            // Save the entry to Core Data
            saveToCoreData(office: office, date: date, timeIn: timeIn, timeOut: timeOut)
            
            // Show a success message
            showSuccessMessage()
        }
        
        // Core Data: Save the work entry
    // This method is used to save a work entry into Core Data
    func saveToCoreData(office: String, date: Date, timeIn: Date, timeOut: Date) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a new WorkEntry entity
        let newWorkEntry = WorkEntry(context: context)
        newWorkEntry.office = office
        newWorkEntry.date = date // Use the day-level date, without time
        newWorkEntry.dateIn = timeIn // The specific clock-in time
        newWorkEntry.dateOut = timeOut // The specific clock-out time
        
        // Save the context
        do {
            try context.save()
            print("Work entry saved!")
        } catch {
            print("Failed to save work entry: \(error)")
        }
    }

        
    func isDateAlreadyUsed(date: Date) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context = appDelegate.persistentContainer.viewContext

        // Create a fetch request for WorkEntry
        let fetchRequest: NSFetchRequest<WorkEntry> = WorkEntry.fetchRequest()

        // Fetch all entries
        do {
            let workEntries = try context.fetch(fetchRequest)
            
            // Date comparison: Only compare the year, month, and day
            let calendar = Calendar.current
            for entry in workEntries {
                if let savedDate = entry.date {
                    let savedComponents = calendar.dateComponents([.year, .month, .day], from: savedDate)
                    let newEntryComponents = calendar.dateComponents([.year, .month, .day], from: date)
                    
                    if savedComponents == newEntryComponents {
                        // If the date matches, we have a duplicate
                        return true
                    }
                }
            }
        } catch {
            print("Failed to fetch work entries: \(error)")
            return false
        }
        
        return false
    }
    
    func fetchWorkEntries() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for WorkEntry entities
        let fetchRequest: NSFetchRequest<WorkEntry> = WorkEntry.fetchRequest()
        
        do {
            let workEntries = try context.fetch(fetchRequest)
            
            // Debugging: Print the fetched entries to see if duplicates are present
            for entry in workEntries {
                print("Fetched entry: \(entry.office ?? ""), \(entry.date ?? Date())")
            }
        } catch {
            print("Failed to fetch work entries: \(error)")
        }
    }
    
        
        // MARK: - Show Success and Error Messages
        func showSuccessMessage() {
            let alert = UIAlertController(title: "Success", message: "Work entry saved successfully!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        func showErrorMessage() {
            let alert = UIAlertController(title: "Error", message: "An entry with this date already exists.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
