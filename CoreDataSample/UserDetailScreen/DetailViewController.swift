//
//  DetailViewController.swift
//  CoreDataSample
//
//  Created by Sultan on 25.09.2023.
//

import UIKit
import SnapKit
import CoreData
import Foundation

protocol DetailViewDelegate: NSObjectProtocol {
    var person: NSManagedObject? { get set }
    func showUIAlert(message: String)
}

class DetailViewController: UIViewController, DetailViewDelegate {

    private let detailPresenter = DetailPresenter()
    var isEditingMode = false
    var person: NSManagedObject? {
        didSet {
            nameTextField.text = person?.value(forKey: "name") as? String
            genderTextField.text = person?.value(forKey: "gender") as? String
            let date = person?.value(forKey: "dateOfBirth") as? Date
            dateOfBirthTextField.text = detailPresenter.convertDateToString(date: date)
        }
    }

    // MARK: - UI

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        button.tintColor = .lightGray
        return button
    }()

    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(editUser), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "avatar")
        imageView.layer.cornerRadius = 70
        return imageView
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isUserInteractionEnabled = false
        textField.setLeftIcon(UIImage(systemName: "person")!)
        textField.setRightPadding(10.0)
        textField.layer.cornerRadius = 10
        return textField
    }()

    private lazy var dateOfBirthTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.placeholder = "11.01.2000"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isUserInteractionEnabled = false
        textField.setLeftIcon(UIImage(systemName: "calendar")!)
        textField.setRightPadding(10.0)
        textField.layer.cornerRadius = 10
        return textField
    }()

    private lazy var genderTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.placeholder = "male"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isUserInteractionEnabled = false
        textField.setLeftIcon(UIImage(systemName: "person.2.circle")!)
        textField.setRightPadding(10.0)
        textField.layer.cornerRadius = 10
        return textField
    }()


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        detailPresenter.setViewDelegate(detailViewDelegate: self)
    }

    // MARK: - Setup

    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(backButton)
        view.addSubview(editButton)
        view.addSubview(avatarImageView)
        view.addSubview(nameTextField)
        view.addSubview(dateOfBirthTextField)
        view.addSubview(genderTextField)
    }

    func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(30)
            make.height.equalTo(20)
        }
        editButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(140)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(50)
        }
        dateOfBirthTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(50)
        }
        genderTextField.snp.makeConstraints { make in
            make.top.equalTo(dateOfBirthTextField.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(50)
        }
    }

    // MARK: - Actions

    @objc func editUser() {
        if isEditingMode {
            nameTextField.isUserInteractionEnabled = false
            dateOfBirthTextField.isUserInteractionEnabled = false
            genderTextField.isUserInteractionEnabled = false
            isEditingMode = false
            editButton.setTitle("Edit", for: .normal)
            detailPresenter.updatePerson(name: nameTextField.text, date: dateOfBirthTextField.text, gender: genderTextField.text)
        } else {
            nameTextField.isUserInteractionEnabled = true
            dateOfBirthTextField.isUserInteractionEnabled = true
            genderTextField.isUserInteractionEnabled = true
            isEditingMode = true
            editButton.setTitle("Save", for: .normal)
        }
    }

    @objc func goBack() {
        let viewController = UserListViewController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeViewController(
                viewController: viewController,
                animated: true,
                animationOptions: .transitionFlipFromRight
        )
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
