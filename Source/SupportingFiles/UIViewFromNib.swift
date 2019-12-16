//
//  UIViewFromNib.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 1/10/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit

func instanceFromNib(nibName: String) -> UIView {
  return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
}
