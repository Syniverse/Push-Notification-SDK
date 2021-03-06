//
//  NotificationTableViewCell.swift
//  SCGPushDemo
//
//  Created by Nelko Nedelchev on 3/21/17.
//  Copyright © 2017 softavail. All rights reserved.
//

import UIKit

protocol NotificationTableViewCellDelegate: class {
    
    func didClickDelivery(cell:NotificationTableViewCell)
    func didClickRead(cell:NotificationTableViewCell)
    func didClickThru(cell:NotificationTableViewCell)
    func didClickDelete(cell:NotificationTableViewCell)
    func didClickDeepLink(cell:NotificationTableViewCell)
    func didClickAttachment(cell:NotificationTableViewCell)
}

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var labelBody: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var constraintTopSpaceToLabelDate: NSLayoutConstraint!
    @IBOutlet weak var constraintVerticalSpaceBodyToDelivery: NSLayoutConstraint!
    @IBOutlet weak var constraintVertialSpaceClickToDelete: NSLayoutConstraint!
    
    @IBOutlet weak var deliveryButton: UIButton!
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var thruButton: UIButton!
    
    @IBOutlet weak var attachmentButton: UIButton!
    @IBOutlet weak var deepLinkButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate:NotificationTableViewCellDelegate?
    
    var deepLink:String?

    var message: SCGPushMessage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        labelDate.backgroundColor = UIColor.clear
        labelDate.numberOfLines = 1
        
        labelBody.numberOfLines = 0
        
        let imageRed            = UIImage(named: "buttonRed.png") as UIImage!
        let imageFinalRed       = imageRed?.resizableImage(withCapInsets: UIEdgeInsetsMake(3, 3, 3, 3))
        
        let imageBlue           = UIImage(named: "buttonBlue.png") as UIImage!
        let imageFinalBlue      = imageBlue?.resizableImage(withCapInsets: UIEdgeInsetsMake(3, 3, 3, 3))
        
        let imageGreen          = UIImage(named: "buttonGreen.png") as UIImage!
        let imageFinalGreen     = imageGreen?.resizableImage(withCapInsets: UIEdgeInsetsMake(3, 3, 3, 3))

        let imagePink           = UIImage(named: "buttonPink.png") as UIImage!
        let imageFinalPink      = imagePink?.resizableImage(withCapInsets: UIEdgeInsetsMake(3, 3, 3, 3))

        let imageOrange         = UIImage(named: "buttonOrange.png") as UIImage!
        let imageFinalOrange    = imageOrange?.resizableImage(withCapInsets: UIEdgeInsetsMake(3, 3, 3, 3))
        
        self.deleteButton.setBackgroundImage(imageFinalRed, for: UIControlState.normal)
        self.thruButton.setBackgroundImage(imageFinalGreen, for: UIControlState.normal)
        self.deepLinkButton.setBackgroundImage(imageFinalBlue, for: UIControlState.normal)
        self.attachmentButton.setBackgroundImage(imageFinalBlue, for: UIControlState.normal)
        self.deliveryButton.setBackgroundImage(imageFinalOrange, for: UIControlState.normal)
        self.readButton.setBackgroundImage(imageFinalPink, for: UIControlState.normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickDelivery(_ sender: Any) {
        
        delegate?.didClickDelivery(cell: self)
    }
    
    @IBAction func onClickDelete(_ sender: Any) {
        
        delegate?.didClickDelete(cell: self)
    }
    
    @IBAction func onClickDeepLink(_ sender: Any) {
        
        delegate?.didClickDeepLink(cell: self)
    }
    
    @IBAction func onClickThru(_ sender: Any) {
        
        delegate?.didClickThru(cell: self)
    }
    
    @IBAction func onClickRead(_ sender: Any) {
        
        delegate?.didClickRead(cell: self)
    }

    @IBAction func onClickAttachment(_ sender: Any) {
        
        delegate?.didClickAttachment(cell: self)
    }
}
