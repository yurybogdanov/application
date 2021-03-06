//
//  RegistrationController.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 19.03.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

class RegistrationController {

  static func loadRegFromServer(
    with id: Int,
    completion: @escaping (_ displayCollection: FormDisplayCollection?, _ error: ServerError?) -> Void) {
    Server.standard.request(EventRegFormPlainObject.Requests.form(with: id)) { form, error in

      guard error == nil else {
        DispatchQueue.main.async {
          completion(nil, error)
        }
        return
      }

      guard let form = form else {
        return
      }

      let formData = FormData(with: form)
      let displayCollection = FormDisplayCollection(formData: formData)
      DispatchQueue.main.async {
        completion(displayCollection, nil)
      }
    }
  }

  static func sendFormData(_ data: FormData, completion: @escaping SuccessCompletionBlock) {
    let regFormRequest = EventRegFormPlainObject.Requests.registration(with: data)
    Server.standard.request(regFormRequest) { response, _ in
      if let response = response {
        completion(response.success)
      } else {
        completion(false)
      }
    }
  }

  static func unregister(for event: Int, completion: @escaping SuccessCompletionBlock) {
    let cancelRequest = EventRegFormPlainObject.Requests.cancel(for: event)
    Server.standard.request(cancelRequest) { response, _ in
      if let response = response {
        completion(response.success)
      } else {
        completion(false)
      }
    }
  }

}
