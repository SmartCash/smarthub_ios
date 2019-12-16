//
//  AddressBookViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 8/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class AddressBookViewController: UITableViewController {
  
  var viewModel: AddressBookViewModel!
  var loadingView: UIView = LoadingView.make()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.viewDidLoad()
    prepareNavigationController()
    
    refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Analytics.setScreenName("Address Book", screenClass: nil)
  }
  
  // MARK: Actions
  
  @IBAction func cancelAction(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func addAction(_ sender: Any) {
    let storyboard = UIStoryboard(name: "AddressBook", bundle: nil)
    if let addressBookAddNavController = storyboard.instantiateViewController(withIdentifier: "AddressBookAddViewController") as? UINavigationController {
      if let addressBookAddViewController = addressBookAddNavController.viewControllers.first as? AddressBookAddViewController {
        let addressBookAddViewModel = AddressBookAddViewModel(viewController: addressBookAddViewController, delegate: self)
        addressBookAddViewController.viewModel = addressBookAddViewModel
        present(addressBookAddNavController, animated: true, completion: nil)
      }
    }
  }
  
  // MARK: Private
  
  @objc func refresh() {
    viewModel.getAddressBook(force: true)
  }
  
  private func prepareNavigationController() {
    title = "Address Book"
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
    }
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.addresses.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell") as? AddressTableViewCell{
      cell.configure(address: viewModel.addresses[indexPath.row], index: indexPath.row)
      
      cell.onDeleteContact = { [weak self] addressId in
        guard let id = addressId else { return }
        let address = self?.viewModel.addresses.filter {$0.id == id}.first
        guard address != nil else { return }
        let index = self?.viewModel.addresses.index(of: address!)
        
        guard index != nil else { return }
        self?.sureToRemove(contactName: address!.name, completion: { [weak self] toRemove in
          if toRemove {
            self?.viewModel.addresses.remove(at: index!)
            self?.tableView.deleteRows(at: [IndexPath(row: index!, section: 0)], with: .fade)
            self?.viewModel.deleteAddress(id: id)
            self?.tableView.reloadData()
          }
        })
      }
      return cell
    }
    return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.didSelectAddress(index: indexPath.row)
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      sureToRemove(contactName: viewModel.addresses[indexPath.row].name, completion: { [weak self] toRemove in
        if toRemove {
          guard let id = self?.viewModel.addresses[indexPath.row].id else { return }
          self?.viewModel.deleteAddress(id: id)
          self?.viewModel.addresses.remove(at: indexPath.row)
          tableView.deleteRows(at: [indexPath], with: .fade)
        }
      })
    }
  }

  
  private func sureToRemove(contactName: String, completion: @escaping (Bool) -> ()) {
    let alertController = UIAlertController(title: nil, message: "Are you sure you want to remove \(contactName)?", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .destructive) { _ in
      completion(true)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
      completion(false)
    }
    alertController.addAction(okAction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true, completion: nil)
  }
  
  
  
  
}

extension AddressBookViewController: AddressBookViewControllerProtocol {
  
  func displayError(message: String) {
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  func update() {
    refreshControl?.endRefreshing()
    tableView.reloadData()
  }
  
  func dismissScreen() {
    dismiss(animated: true, completion: nil)
  }
}

extension AddressBookViewController: AddressBookAddProtocol {
  func didSave(address: String) {
    viewModel.getAddressBook(force: true)
  }
}
