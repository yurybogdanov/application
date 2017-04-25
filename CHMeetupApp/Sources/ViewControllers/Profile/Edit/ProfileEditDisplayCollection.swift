//
//  ProfileEditDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 18/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class ProfileEditDisplayCollection: DisplayCollection {
  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [ChooseProfilePhotoTableViewModel.self,
            LabelTableViewCellModel.self]
  }

  enum `Type` {
    case userHeader
    case userContacts
  }

  fileprivate var sections: [Type] = [.userHeader, .userContacts]

  var user: UserEntity!

  var numberOfSections: Int {
    return sections.count
  }

  func numberOfRows(in section: Int) -> Int {
    switch sections[section] {
    case .userHeader:
      return 1
    case .userContacts:
      return user.contacts.count
    }
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    switch sections[indexPath.section] {
    case .userHeader:
      return ChooseProfilePhotoTableViewModel(userEntity: user, delegate: self)
    case .userContacts:
      let key = Array(user.contacts.keys).sorted(by: > )[indexPath.row]
      let value = user.contacts[key] ?? ""
      return LabelTableViewCellModel(title: key, description: value)
    }
  }
}

extension ProfileEditDisplayCollection: ChooseProfilePhotoTableViewCellDelegate {
  func chooseProfilePhotoCellDidPressOnPhoto(_ cell: ChooseProfilePhotoTableViewCell) {
    print("Tapped")
  }
}
