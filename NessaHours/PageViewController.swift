import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    // Array to hold the view controllers for each page
    lazy var orderedViewControllers: [UIViewController] = {
        return [
            self.newViewController(identifier: "IntroVC"),
            self.newViewController(identifier: "AddWorkVC"),
            self.newViewController(identifier: "CalculateHoursVC"),
            self.newViewController(identifier: "EntriesListVC")
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self

        // Start with the first view controller (Intro)
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }

    // Helper method to instantiate view controllers from the storyboard
    func newViewController(identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }

    // MARK: - Page View Controller Data Source Methods

    // Return the previous view controller (for swiping left)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        // If the previous index is valid, return the view controller at that index
        guard previousIndex >= 0 else {
            return nil // Return nil if already on the first page
        }

        return orderedViewControllers[previousIndex]
    }

    // Return the next view controller (for swiping right)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1

        // If the next index is valid, return the view controller at that index
        guard nextIndex < orderedViewControllers.count else {
            return nil // Return nil if already on the last page
        }

        return orderedViewControllers[nextIndex]
    }

    // Optional: For displaying page dots
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
              let firstViewControllerIndex = orderedViewControllers.firstIndex(of: firstViewController) else {
            return 0
        }

        return firstViewControllerIndex
    }
}
