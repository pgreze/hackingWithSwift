## https://www.hackingwithswift.com/read

https://github.com/twostraws/HackingWithSwift

### https://www.hackingwithswift.com/read/1/overview

https://www.hackingwithswift.com/read/1/3/designing-our-interface
+ UITableViewController initial view controller
+ NavigationController

https://www.hackingwithswift.com/read/1/5/loading-images-with-uiimage
+ storyboard?.instantiateViewController(withIdentifier
+ navigationController?.pushViewController
+ imageView.image = UIImage(named: imagePath)

https://www.hackingwithswift.com/read/1/6/final-tweaks-hidesbarsontap-and-large-titles
+ image aspectfit
+ viewWillAppear `navigationController?.hidesBarsOnTap = true` to hide nav bar if click image
+ `Accessory: Disclosure Indicator` to show the > arrow in all cells (aka Disclosure Indicator)
+ custom VC title in code
+ `navigationController?.navigationBar.prefersLargeTitles = true` for large header
+ `navigationItem.largeTitleDisplayMode = .never` override for the detail screen only

### https://www.hackingwithswift.com/read/2/overview

https://www.hackingwithswift.com/read/2/5/from-outlets-to-actions-creating-an-ibaction
+ UIAlertController

Was not so interesting, so I wrote UI programmatically
and added horizontal/vertical support.

(leading // trailing) == (left // right)

### https://www.hackingwithswift.com/read/3/overview

https://www.hackingwithswift.com/read/3/2/uiactivityviewcontroller-explained

Share button in the nav. bar:
```swift
navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
```

shareTapped function:
```swift
guard let image: Data = imageView.image?.jpegData(compressionQuality: 0.8) else {
    print("No image to share")
    return
}
let vc = UIActivityViewController(activityItems: [image, "photo.jpeg"], applicationActivities: [])
// For iPad, allows to show the share dialog next to the button triggering the action.
vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
present(vc, animated: true)
```

### https://www.hackingwithswift.com/read/4/overview

https://www.hackingwithswift.com/read/4/2/creating-a-simple-browser-with-wkwebview

```swift
lazy var webView: WKWebView = {
    let view = WKWebView()
    view.navigationDelegate = self
    return view
}()

override func loadView() {
    view = webView
}

override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
    
    webView.load(URLRequest(url: URL(string: "https://pgreze.dev")!))
    webView.allowsBackForwardNavigationGestures = true
}
```

https://www.hackingwithswift.com/read/4/4/monitoring-page-loads-uitoolbar-and-uiprogressview

key-value observing (KVO):
```swift
// Listen for webView.estimatedProgress updates
webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    // Called after using addObserver
    if keyPath == "estimatedProgress" {
        progressView.isHidden = false
        progressView.progress = Float(webView.estimatedProgress)
    }
}
```
https://developer.apple.com/documentation/webkit/wkwebview/1415007-estimatedprogress

https://www.hackingwithswift.com/read/4/5/refactoring-for-the-win

```swift
func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    guard let host = navigationAction.request.url?.host else { return }
    if !urls.filter({ (url) -> Bool in host.hasSuffix(url) }).isEmpty {
        decisionHandler(.allow)
    } else {
        decisionHandler(.cancel)
    }
}
```

### https://www.hackingwithswift.com/read/5/overview

https://www.hackingwithswift.com/read/5/3/pick-a-word-any-word-uialertcontroller

```swift
guard let path = Bundle.main.url(forResource: "start", withExtension: "txt") else { return }
guard let startWords = try? String(contentsOf: path) else { return }
allWords = startWords.components(separatedBy: "\n")
```

```swift
@objc private func promptForAnswer() {
    let ac = UIAlertController(title: "Answer", message: nil, preferredStyle: .alert)
    ac.addTextField { (textField) in
        textField.accessibilityLabel = "Insert your answer"
    }
    ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self, weak ac] action in
        guard let answer = ac?.textFields?[0].text else { return }
        self?.submit(answer)
    }))
    present(ac, animated: true)
}
```

### https://www.hackingwithswift.com/read/6/overview

https://www.hackingwithswift.com/read/6/2/advanced-auto-layout
+ "Greater Than or Equal" for bottom margin
+ "Equal Heights" for each elements

https://www.hackingwithswift.com/read/6/3/auto-layout-in-code-addconstraints-with-visual-format-language
```swift
let labels = [
    ("THESE", UIColor.red),
    ("ARE", UIColor.cyan),
    ("SOME", UIColor.yellow),
    ("AWESOME", UIColor.green),
    ("LABELS", UIColor.orange),
].enumerated().map { (index, value) -> (String, UILabel) in
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.backgroundColor = value.1
    label.text = value.0
    label.sizeToFit()
    return ("label\(index+1)", label)
}.reduce(into: [:]) { $0[$1.0] = $1.1 }

labels.forEach { view.addSubview($0.value) }

for label in labels.keys {
    // H: = horizontal, | = the edge of the view (=VC)
    // == each of our labels should stretch edge-to-edge in our view
    // Exp: H:|[label1]|
    addConstraints(withVisualFormat: "H:|[\(label)]|")
}
// "-" = means "space". It's 10 points by default.
// == "V:|[label1]-[label2]-[label3]-[label4]-[label5]"
addConstraints(withVisualFormat: "V:|\(labels.keys.map { "[\($0)]" }.joined(separator: "-"))")

private func addConstraints(withVisualFormat: String) {
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: withVisualFormat, options: [], metrics: nil, views: labels))
}
```

https://www.hackingwithswift.com/read/6/4/auto-layout-metrics-and-priorities-constraintswithvisualformat

Use metrics as constants:
```swift
let metrics = ["labelHeight": 88]
view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight)]-[label2(labelHeight)]-[label3(labelHeight)]-[label4(labelHeight)]-[label5(labelHeight)]->=10-|", options: [], metrics: metrics, views: labels))
```

Priority (default: 1000):
```swift
"V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]->=10-|"
```

https://www.hackingwithswift.com/read/6/5/auto-layout-anchors

```swift
for label in [label1, label2, label3, label4, label5] {
    label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    label.heightAnchor.constraint(equalToConstant: 88).isActive = true
}
```

https://theswiftdev.com/mastering-ios-auto-layout-anchors-programmatically-from-swift/

### https://www.hackingwithswift.com/read/8/overview

https://www.hackingwithswift.com/read/8/2/building-a-uikit-user-interface-programmatically
+ create UILabel programatically
+ NSLayoutConstraint.activate([ scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),

### https://www.hackingwithswift.com/read/9/overview

```swift
// https://www.hackingwithswift.com/read/9/3/gcd-101-async
DispatchQueue.global(qos: .userInitiated).async { [weak self] in
    ...
}

// https://www.hackingwithswift.com/read/9/4/back-to-the-main-thread-dispatchqueuemain
DispatchQueue.main.async { self.tableView.reloadData() }

// https://www.hackingwithswift.com/read/9/5/easy-gcd-using-performselectorinbackground
performSelector(inBackground: #selector(fetchJson), with: nil)
// And for UI:
tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
```

### https://www.hackingwithswift.com/read/10/overview

CollectionView!!

```swift
// https://www.hackingwithswift.com/read/10/4/importing-photos-with-uiimagepickercontroller
navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))

@objc func addNewPerson() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
}

// https://www.hackingwithswift.com/read/10/5/custom-subclasses-of-nsobject
class Person : NSObject {
}
```

### https://www.hackingwithswift.com/read/12/overview

```swift
// https://www.hackingwithswift.com/read/12/2/reading-and-writing-basics-userdefaults
// NSCoding is objc compatible
class Person: NSObject, NSCoding {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        image = coder.decodeObject(forKey: "image") as? String ?? ""
    }
}
func load() {
    let defaults = UserDefaults.standard
    if let savedPeople = defaults.object(forKey: "people") as? Data {
        if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
            people = decodedPeople
        }
    }
}
func save() {
    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "people")
    }
}

// Codable is easier to use but swift only
class Person: NSObject, Codable { //, NSCoding {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
func load() {
    let defaults = UserDefaults.standard
    if let savedPeople = defaults.object(forKey: "people") as? Data {
        let jsonDecoder = JSONDecoder()
        do {
            people = try jsonDecoder.decode([Person].self, from: savedPeople)
        } catch {
            print("Failed to load people")
        }
    }
}
func save() {
    let jsonEncoder = JSONEncoder()
    if let savedData: Data = try? jsonEncoder.encode(people) {
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "people")
    }
```
