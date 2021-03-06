//
//  BeaconTransmitter.swift
//  CHMeetupApp
//
//  Created by Chingis Gomboev on 15/03/2018.
//  Copyright © 2018 CocoaHeads Community. All rights reserved.
//

import Foundation
import CoreBluetooth

final class BeaconTransmitter: NSObject {

  // MARK: - Properties

  private var peripheralManager: CBPeripheralManager?
  private let userData: Data
  private var bluetoothIsEnabledAndAuthorized = false

  // MARK: - Public

  public init(userData: Data) {
    self.userData = userData
    super.init()

    bluetoothIsEnabledAndAuthorized = hasBluetooth()
  }

  public func startTransmitting() {
    guard canTransmit() else {
      return
    }

    startBluetoothTransmitting()
  }

  public func stopTransmitting() {

    peripheralManager?.stopAdvertising()
    peripheralManager = nil
  }

  public var isTransmitting: Bool {
    return peripheralManager?.isAdvertising == true
  }

  // MARK: - Private

  private func canTransmit() -> Bool {
    let status = CBPeripheralManager.authorizationStatus()
    let enabled = status == .authorized || status == .notDetermined
    if !enabled {
      print("bluetooth not authorized")
    }
    return enabled

  }

  private func startBluetoothTransmitting() {
    if peripheralManager == nil {
      peripheralManager?.delegate = self
      peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
  }

  private func hasBluetooth() -> Bool {
    return canTransmit() && peripheralManager?.state == .poweredOn
  }

  private func startAdvertising() {

    let advertisingData: [String: Any] = [
      CBAdvertisementDataLocalNameKey: BeaconConstans.localNameKey,
      CBAdvertisementDataServiceUUIDsKey: [BeaconConstans.serviceUUID]
    ]
    let service = CBMutableService(type: BeaconConstans.serviceUUID, primary: true)

    let data = userData
    let characteristic = CBMutableCharacteristic(
      type: BeaconConstans.characteristicUUID,
      properties: .read,
      value: data,
      permissions: .readable
    )
    service.characteristics = [characteristic]
    peripheralManager?.add(service)
    peripheralManager?.startAdvertising(advertisingData)
  }
}

extension BeaconTransmitter: CBPeripheralManagerDelegate {
  func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
    print("-- peripheral state changed: \(peripheral.state)")
    if peripheral.state == .poweredOn {
      startAdvertising()
    }

  }

  func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
    if let err = error {
      print("error starting advertising: \(err.localizedDescription)")
    } else {
      print("did start advertising")
    }
  }
}
