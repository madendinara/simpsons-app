//
//  ListCell.swift
//  simpsons-app
//
//  Created by Динара Зиманова on 4/26/23.
//

import UIKit

class ListCell: UITableViewCell {
    
    @IBOutlet weak var characterName: UILabel!
    
    
    override func prepareForReuse() {
        characterName.text = ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
}

