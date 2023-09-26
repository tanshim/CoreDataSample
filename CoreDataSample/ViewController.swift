//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Sultan on 24.09.2023.
//

import UIKit
import SnapKit
import CoreData

class ViewController: UIViewController {

    var people: [NSManagedObject] = []

    // MARK: - UI

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Print your name"
        textField.textColor = .black
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.setLeftPadding(10.0)
        textField.setRightPadding(10.0)
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor(red: 0.75, green: 0.83, blue: 0.95, alpha: 1.00)
        return textField
    }()

    private lazy var addUserButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add User", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(addUser), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()

    private lazy var usersTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 10
        tableView.rowHeight = 50
        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        fetchPersons()
    }

    // MARK: - Setup

    func setupViews() {
        view.backgroundColor = .white
        title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(nameTextField)
        view.addSubview(addUserButton)
        view.addSubview(usersTableView)
    }

    func setupConstraints() {
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(50)
        }
        addUserButton.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(50)
        }
        usersTableView.snp.makeConstraints { make in
            make.top.equalTo(addUserButton.snp.bottom).offset(15)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    // MARK: - Actions

    @objc func addUser() {
        guard let name = nameTextField.text,
              name.count > 0 else {
            self.showUIAlert(message: "Enter name!")
            return
        }
        nameTextField.text = ""
        self.savePerson(name: name)
        self.usersTableView.reloadData()
    }

    func savePerson(name: String) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person",
                                                in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            showUIAlert(message: "Could not save. \(error), \(error.userInfo)")
        }
    }

    func fetchPersons() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            showUIAlert(message: "Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func showUIAlert(message: String) {
        let action = UIAlertAction(title: "OK", style: .destructive)
        let alertController
        = UIAlertController(title: "Error!",
                            message: message,
                            preferredStyle: .alert)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }

}

    // MARK: - Table View

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let person = people[indexPath.row]
        cell.textLabel?.text = person.value(forKey: "name") as? String
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let person = people[indexPath.row]
            guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.persistentContainer.viewContext.delete(person)
            people.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            appDelegate.saveContext()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let person = people[indexPath.row]
        let detailViewController = DetailViewController()
        detailViewController.person = person
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeViewController(
                viewController: detailViewController,
                animated: true,
                animationOptions: .transitionFlipFromLeft
        )
    }

}
