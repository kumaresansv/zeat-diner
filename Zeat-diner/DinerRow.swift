//
//  DinerRow.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 11/5/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit

class DinerRow: UITableViewCell {
    
    var currentOrder: Order?
    
    @IBOutlet weak var dinerCollection: UICollectionView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}

extension DinerRow: UICollectionViewDataSource {
//    func collec
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let diners = currentOrder?.diners
            else {
            return 0
        }
        return diners.count

//        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dinerCell", for: indexPath) as? DinerCell
//        cell.diner
        cell?.dinerName?.text = currentOrder?.diners![indexPath.row].nickname
        cell?.dinerImage?.setImage(string: currentOrder?.diners![indexPath.row].nickname, color: UIColor.colorHash(name: currentOrder?.diners![indexPath.row].nickname) , circular: true, textAttributes: nil)
//        cell?.dinerImage.setImage
        return cell!
    }
}
