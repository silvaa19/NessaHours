import UIKit
import CoreData

class EditWorkViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var officePicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateInPicker: UIDatePicker!
    @IBOutlet weak var dateOutPicker: UIDatePicker!
    
    var selectedEntry: WorkEntry? // This will hold the entry being edited
    let officeList = ["Bronx", "212A", "308B", "PalmerRd"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        officePicker.delegate = self
        officePicker.dataSource = self

        // Set the current values for the selected entry
        if let entry = selectedEntry {
            if let office = entry.office, let index = officeList.firstIndex(of: office) {
                officePicker.selectRow(index, inComponent: 0, animated: false)
            }
            datePicker.date = entry.date ?? Date()
            dateInPicker.date = entry.dateIn ?? Date()
            dateOutPicker.date = entry.dateOut ?? Date()
        }
    }

    // MARK: - UIPickerView DataSource and Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return officeList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return officeList[row]
    }

    // MARK: - Save Changes
    @IBAction func saveChanges(_ sender: UIButton) {
        guard let entry = selectedEntry else { return }

        let selectedOfficeIndex = officePicker.selectedRow(inComponent: 0)
        entry.office = officeList[selectedOfficeIndex]
        entry.date = datePicker.date
        entry.dateIn = dateInPicker.date
        entry.dateOut = dateOutPicker.date
        
        // Save changes to Core Data
        saveChangesToCoreData()

        // Dismiss the view controller
        navigationController?.popViewController(animated: true)
    }

    func saveChangesToCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        do {
            try context.save()
            print("Work entry updated successfully!")
        } catch {
            print("Failed to update work entry: \(error)")
        }
    }
}
