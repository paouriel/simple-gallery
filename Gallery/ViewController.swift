import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageDisplay: UIImageView!
    @IBOutlet weak var imageSlider: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageSlider.isUserInteractionEnabled = true
        imageSlider.showsHorizontalScrollIndicator = false
        imageSlider.showsVerticalScrollIndicator = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func downloadImage(_ sender: Any) {
        for x in 0 ... 7 {
            downloadImageFromWeb(sender: x)
        }
        
    }
    
    var image: UIImageView!

    @IBAction func addItem(_ sender: Any) {
        var contentWidth: Int = 70
        let contentHeight: Int = 95
        
        for x in 0 ... 7 {
            image = UIImageView(frame: CGRect(x: (x*80), y: 0, width: 70, height: 95))
            contentWidth += 72
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            image.isUserInteractionEnabled = true
            image.addGestureRecognizer(tapGestureRecognizer)
            
            loadImageFromGallery(sender: image, index: x)
            image.target(forAction: #selector(imageTapped), withSender: self)
            imageSlider.addSubview(image)
        }
        
        imageSlider.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let imageRetrieved = tapGestureRecognizer.view as! UIImageView
        if let image = imageRetrieved.image {
            imageDisplay.image = image
        }
        
        // Your action
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let touch = touches.first {
            if touch.view == self.imageSlider { //image View property
                print("Image pressed")
            }
        }
    }
    
    func imageTap(sender: UIImageView!) {
        imageDisplay.image = sender.image
        print("Image pressed")
    }
    
    var urls : [URL] = [URL(string: "https://pbs.twimg.com/media/DD79O1DUMAAI01Y.jpg")!,
                        URL(string: "http://www.uni-regensburg.de/Fakultaeten/phil_Fak_II/Psychologie/Psy_II/beautycheck/english/durchschnittsgesichter/m(01-32)_gr.jpg")!,
                        URL(string: "https://static01.nyt.com/images/2011/07/31/sunday-review/FACES/FACES-jumbo.jpg")!,
                        URL(string: "http://www3.pictures.zimbio.com/mp/Bl5sChBTmDgx.jpg")!,
                        URL(string: "https://www.sciencenewsforstudents.org/sites/default/files/scald-image/350_.inline2_beauty_w.png")!,
                        URL(string: "http://facefacts.scot/images/people/ben_jones")!,
                        URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnxZJknBapktW7yspPZCsFdlo_B1lpfKteUItthWRTdn2arSKyRQ")!,
                        URL(string: "http://museum.wa.gov.au/sites/default/files/imagecache/wam_v2_article_half_nocrop/webform/wa-faces/WAM_NMP_WA%20Faces%20Katanning%20Angela_b_website.jpg")!]

    
    func downloadImageFromWeb(sender: Int) {
        let url = urls[sender]
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print(error!)
            } else {
                
                //force unwrap if there is value
                if let data = data {
                    
                    //convert data into an image
                    if let bachImage = UIImage(data: data) {
                        
                        //Search for document directory
                        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                        
                        if documentsPath.count > 0 {
                            print("document path found")
                            //Get specific path
                            let documentsDirectory = documentsPath[0]
                            
                            //if document path is found
                            let savePath = documentsDirectory + "/image"+String(sender)+".jpg"
                            
                            do {
                                print("Image saved")
                                try UIImageJPEGRepresentation(bachImage, 1)?.write(to: URL(fileURLWithPath: savePath))
                            } catch {
                                print("Image save error")
                                //process error
                            }
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    func loadImageFromGallery (sender: UIImageView, index: Int!) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print("retrieving")
        if documentsPath.count > 0 {
            print("retrieved")
            let documentsDirectory = documentsPath[0]
            let restorePath = documentsDirectory + "/image"+String(index)+".jpg"
            sender.image = UIImage(contentsOfFile: restorePath)
            print("image set")
        } else {
            print("error retrieving")
        }
    }

}

