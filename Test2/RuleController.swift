// Controller for a sigular rule.

import UIKit

class RuleController: UITableViewController {
    @IBOutlet var nav: UINavigationItem!
    @IBOutlet var nameTextField: UILabel!
    @IBOutlet var calendarsTextField: UILabel!
    @IBOutlet var searchTextField: UILabel!
    @IBOutlet var replacementTextField: UILabel!
    @IBOutlet var omniButton: UIButton!
    var mode: RuleControllerMode = .new
    var rule: Rule?
    var rc: RulesController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch mode {
        case .new:
            let fields = [nameTextField, calendarsTextField, searchTextField, replacementTextField]
            fields.forEach{element in element!.text = ""}
            nav.title = "New Rule"
            omniButton.setTitle("Create Rule", for: .normal)
        case .editing:
            guard let theRule = rule else {
                return
            }
            
            nameTextField.text = theRule.name
            omniButton.setTitle("Run Rule", for: .normal)
        }
    }
    
    @IBAction func omniPressed(_ sender: Any) {
        switch mode {
        case .new:
            //rc?.addNewRule(rule: Rule()
            _ = navigationController?.popViewController(animated: true)
        case .editing:
            return
        }
    }
    
    func loadNew(parent: RulesController) {
        rc = parent
        mode = .new
    }
    
    func loadEdit(newRule: Rule) {
        rule = newRule
        mode = .editing
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let target = segue.destination as! RCEditorController
        target.setRC(ruleController: self)
    }
}

enum RuleControllerMode {
    case new
    case editing
}

protocol RCEditorController {
    func setRC(ruleController: RuleController)
}
