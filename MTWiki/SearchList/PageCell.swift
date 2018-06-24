//
//  PageCell.swift
//  MTWiki
//
//  Created by Rahul Sharma on 23/06/18.
//  Copyright © 2018 Rahul Sharma. All rights reserved.
//



import UIKit

class PageCell: UITableViewCell {


    @IBOutlet weak var pageImage: UIImageView!

    @IBOutlet weak var pageName: UILabel!
    @IBOutlet weak var pageRole: UILabel!

    var mPage:Page? = nil
    var mHistory:History? = nil
    var status:String? = nil

    var showCheckImage:Bool? = nil

    func hisoryPrepare(){
        if mHistory != nil {
            self.pageName.text = (mHistory!.title != nil) ? mHistory!.title!: ""
            if(mHistory?.thumbnailSource != nil ){
                self.pageImage.sd_setImage(with:  URL.init(string: (mHistory?.thumbnailSource)!), placeholderImage: UIImage(named: "WikipediaLogo"))

            }else{
                self.pageImage.image = UIImage(named: "WikipediaLogo")
            }

            self.pageRole.text =  mHistory?.descriptionWiki

        }
    }
    func prepare(){
        if mPage != nil {
            self.pageName.text = (mPage!.title != nil) ? mPage!.title!: ""
            if(mPage?.thumbnailSource != nil ){
            self.pageImage.sd_setImage(with:  URL.init(string: (mPage?.thumbnailSource)!), placeholderImage: UIImage(named: "WikipediaLogo"))
            
            }else{
                self.pageImage.image = UIImage(named: "WikipediaLogo")
            }

            self.pageRole.text =  mPage?.descriptionWiki

        }

    }

    func makeSelected(selected:Bool){
        self.contentView.backgroundColor = selected ? UIColor.blue: UIColor.white
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pageImage.clipsToBounds=true
        self.pageImage.layer.cornerRadius = 27.0
        self.pageName.textColor = UIColor.init(white: 0.2, alpha: 1)
        self.pageRole.textColor = UIColor.init(white: 0.4, alpha: 1)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mPage = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
