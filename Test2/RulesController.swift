// Controller to manage list of rules
// I apoligise in advance for the terrible name.

import UIKit

class RulesController: UITableViewController {
    @IBOutlet var table: UITableView!
    var rules = [Rule(name: "Rule 1"), Rule(name: "Rule 2")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rule_cell", for: indexPath as IndexPath) as! RuleCell
        cell.name!.text = rules[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rules.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "new_rule_segue":
            let vc = segue.destination as! RuleController
            vc.loadNew(parent: self)
        case "edit_rule_segue":
            let vc = segue.destination as! RuleController
            let cell = sender as! UITableViewCell
            let i = table.indexPath(for: cell)!.row
            vc.loadEdit(newRule: rules[i])
        default:
            return
        }
    }
    
    func addNewRule(rule: Rule) {
        rules.append(rule)
    }
    
    func modifyRule(rule: Rule) {
        
    }
}

struct Rule {
    let name: String
    let calendars: [String] = []
    let searchText: String = ""
    let replaceText: String = ""
}
