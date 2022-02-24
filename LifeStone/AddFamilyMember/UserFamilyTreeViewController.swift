//
//  UserFamilyTreeViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 24/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
var flgedittree = false
var datatosnd = FamilyTree()
var SeleNode = Node()
import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import SDWebImage

class UserFamilyTreeViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var CreatePoundView: UIView!
    var scrollfocus:CGPoint = CGPoint.zero
    
    var lineArry: [line_pt] = []
    lazy var dateFormatter: DateFormatter =
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone.current
            return formatter
    }()
    lazy var display_DateFormatter: DateFormatter =
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM, yyyy"
            formatter.timeZone = TimeZone.current
            return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        scrollfocus = self.vw.center
        scrollView.minimumZoomScale = 0.2
        scrollView.maximumZoomScale = 2.0
        // Do any additional setup after loading the view.
        self.clear()
        self.GetData()
        
    }
    
    @IBAction func createPoundClick(_ sender: UIButton) {
        CreatePound()
    }
    func addPoundView()  {
        self.CreatePoundView.frame = self.view.frame
        self.CreatePoundView.alpha = 1
        self.view.addSubview(CreatePoundView)
    }
    func adddata(Data:FamilyTree)  {
//        let temp = FamilyTree()
//        temp.title = "GF"
//        temp.relatives = [getGM(),Get_GF_U(),Get_GF_U(),Get_Fa(),Get_GF_A(),Get_GF_A()]
        lineArry = []
        ManageTree(Data: [Data], Vertical_Pt_Y: 200, Horizontal_Pt_X: self.vw.center.x, isfirst: true)
        DispatchQueue.main.async {
            self.plotLine()
            self.setviewfocus()
        }
    }
    func ManageTree(Data:[FamilyTree],Vertical_Pt_Y:CGFloat,Horizontal_Pt_X:CGFloat,isfirst:Bool)  {
        if Data.count == 0 {return}
        var Vert_Y = Vertical_Pt_Y // is the rows or can say it level like father is level one and Son is level 2
        let Hori_X = Horizontal_Pt_X // is the column for brother and sister
        var linePath = line_pt()
        // Draw Top Tree Node or first Node
        if isfirst{
            DrawNode(Point: CGPoint(x: Hori_X, y: Vert_Y), data: Data[0])
            linePath.startPt = CGPoint(x: Hori_X, y: Vert_Y)
        }
        else{
            if Data[0].relatives.count != 0 {
                linePath.startPt = CGPoint(x: Hori_X, y: Vert_Y)
            }
        }
        
        
        var leftCount = 0
        var rightCount = 0
        
        // Draw and find patner
        for (index,item) in Data[0].relatives.enumerated(){
            if item.roleID == role.patner.rawValue{
                Vert_Y = Vert_Y + 200
                DrawNode(Point: CGPoint(x: Hori_X, y: Vert_Y), data: item)
                Data[0].relatives.remove(at: index)
                
                
                linePath.endPts.append(CGPoint(x: Hori_X, y: Vert_Y))
                lineArry.append(linePath)
                linePath = line_pt()
                linePath.startPt = CGPoint(x: Hori_X, y: Vert_Y)
                
                break
            }
        }
        Vert_Y = Vert_Y + 200
        
        for (index,nodeItem) in Data[0].relatives.enumerated() {
            // other then patner node
            if index == 0{
                linePath.endPts.append(CGPoint(x: Hori_X, y: Vert_Y))
                ManageTree(Data: [nodeItem], Vertical_Pt_Y: Vert_Y, Horizontal_Pt_X: Hori_X, isfirst: false)
                DrawNode(Point: CGPoint(x: Hori_X, y: Vert_Y), data: nodeItem)
            }
            else if index % 2 == 1{
                leftCount = leftCount + 1
                linePath.endPts.append(CGPoint(x: Hori_X - CGFloat(200*leftCount), y: Vert_Y))
                ManageTree(Data: [nodeItem], Vertical_Pt_Y: Vert_Y, Horizontal_Pt_X: Hori_X - CGFloat(200*leftCount), isfirst: false)
                DrawNode(Point: CGPoint(x: Hori_X - CGFloat(200*leftCount), y: Vert_Y), data: nodeItem)
            }
            else{
                rightCount = rightCount + 1
                linePath.endPts.append(CGPoint(x: Hori_X + CGFloat(200*rightCount), y: Vert_Y))
                ManageTree(Data: [nodeItem], Vertical_Pt_Y: Vert_Y, Horizontal_Pt_X: Hori_X + CGFloat(200*rightCount), isfirst: false)
                DrawNode(Point: CGPoint(x: Hori_X + CGFloat(200*rightCount), y: Vert_Y), data: nodeItem)
            }
        }
        lineArry.append(linePath)
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.vw
    }
    func setviewfocus()  {
        let x = self.view.frame.width/2
        let y = self.view.frame.height/2
        self.scrollfocus.x = self.scrollfocus.x-x
        self.scrollfocus.y = self.scrollfocus.y-y
        self.scrollView.setContentOffset(self.scrollfocus, animated: true)
    }
}

extension UserFamilyTreeViewController{
    func DrawNode(Point:CGPoint,data:FamilyTree)  {
        print("p:\(Point)   \(data.title)")
        let TreeNode = Bundle.main.loadNibNamed("Node", owner: nil, options: nil)!.first as! Node // does the same as above
        TreeNode.center = Point
        TreeNode.FirstName.text = data.f_name
        TreeNode.secName.text = data.l_name
        let date:Date = dateFormatter.date(from: data.dob) ?? Date()
        TreeNode.DOB.text = display_DateFormatter.string(from: date)
        TreeNode.userImage.image = #imageLiteral(resourceName: "imaggg")
        TreeNode.plusbtn.addTarget(self, action: #selector(PlusClick(_:)), for: .touchUpInside)
        TreeNode.EditNode.addTarget(self, action: #selector(editNoteClick(_:)), for: .touchUpInside)
        TreeNode.plusbtn.node = TreeNode
        TreeNode.plusbtn.data = data
        TreeNode.EditNode.node = TreeNode
        TreeNode.EditNode.data = data
        TreeNode.isPlusHidden(is: self.isplushidden(data: data, Point: Point))
        self.vw.addSubview(TreeNode)
    }
    
    @objc func editNoteClick(_ sender:MyButton) {
        let Node:Node = sender.node as! Node
        let data:FamilyTree = sender.data as! FamilyTree
        print(data.f_name)
        print(Node.FirstName.text!)
        datatosnd = data
        flgedittree = true
        SeleNode = Node
        self.performSegue(withIdentifier: "editthis", sender: nil)
    }
    @objc func PlusClick(_ sender:MyButton) {
        let Node:Node = sender.node as! Node
        let data:FamilyTree = sender.data as! FamilyTree
        print(data.f_name)
        print(Node.FirstName.text!)
        datatosnd = data
        flgedittree = false
        self.performSegue(withIdentifier: "gotoadd", sender: nil)
    }
    func isplushidden(data:FamilyTree,Point:CGPoint) -> Bool {
        if data.roleID == 5 || data.roleID == 4{
            // 5 for patner and 4 for sister
            return true
        }
        else{
            if data.level == 0{
                if "\(data.user_id)" == AppDelegate.personalInfo.id{
                    scrollfocus = Point
                    return false
                }
                else{return true}
            }
            else if data.level == 1{
                if data.roleID == 1{
                    return false
                }
                else{return true}
            }
            else{
                return false
            }
        }
    }
}
extension UserFamilyTreeViewController{
    // line functions
    func plotLine()  {
        for item in lineArry {
            item.startPt.y = item.startPt.y + 80
            for initem in item.endPts{
                let endpt = CGPoint(x: initem.x, y: initem.y - 80)
                print ("\(item.startPt)  --  \(endpt)")
                PlotLine(startPoint: item.startPt, EndPoint: endpt)
            }
        }
    }
    func clear()  {
        self.vw.layer.sublayers = nil
    }
    func PlotLine(startPoint:CGPoint,EndPoint:CGPoint)  {
        if startPoint.y > EndPoint.y{
            // mean invalid line
            return
        }
        if startPoint.x == EndPoint.x{
            drawLine(startPoint:startPoint,EndPoint:EndPoint, inView: self.vw)
        }
        else if startPoint.x < EndPoint.x{
            let midY:CGFloat = startPoint.y + CGFloat(abs(startPoint.y - EndPoint.y)/2)
            let midX2 = startPoint.x + CGFloat(abs(startPoint.x - EndPoint.x))
            
            drawLine(startPoint: startPoint, EndPoint: CGPoint(x: startPoint.x, y: midY), inView: self.vw)
            drawLine(startPoint: CGPoint(x: startPoint.x, y: midY), EndPoint: CGPoint(x: midX2, y: midY), inView: self.vw)
            drawLine(startPoint: CGPoint(x: midX2, y: midY), EndPoint: EndPoint, inView: self.vw)
            
            print("On Right Side")
        }
        else if startPoint.x > EndPoint.x{
            let midY:CGFloat = startPoint.y + CGFloat(abs(startPoint.y - EndPoint.y)/2)
            let midX2 = CGFloat(abs(EndPoint.x))
            
            drawLine(startPoint: startPoint, EndPoint: CGPoint(x: startPoint.x, y: midY), inView: self.vw)
            drawLine(startPoint: CGPoint(x: startPoint.x, y: midY), EndPoint: CGPoint(x: midX2, y: midY), inView: self.vw)
            drawLine(startPoint: CGPoint(x: midX2, y: midY), EndPoint: EndPoint, inView: self.vw)
            print("On Lift Side")
        }
    }
    func drawLine(startPoint:CGPoint,EndPoint:CGPoint, inView view: UIView) {
        
        let lineColor: UIColor = .lightGray
        let lineWidth: CGFloat = 1
        
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: EndPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        
        view.layer.addSublayer(shapeLayer)
        
    }
}
extension UserFamilyTreeViewController{
    
    func getGM() -> FamilyTree {
        let temp = FamilyTree()
        temp.title = "GM"
        temp.l_name = "ali"
        temp.dob = "1099-05-22"
        temp.roleID = 5
        temp.relatives = []
        return temp
    }
    func Get_GF_U() -> FamilyTree {
        let temp = FamilyTree()
        temp.title = "Uncle"
        temp.l_name = "ali"
        temp.relatives = []
        return temp
    }
    func Get_GF_A() -> FamilyTree {
        let temp = FamilyTree()
        temp.title = "Aunty"
        temp.l_name = "ali"
        temp.dob = "1099-05-22"
        temp.relatives = []
        return temp
    }
    
    func getM() -> FamilyTree {
        let temp = FamilyTree()
        temp.title = "Mother"
        temp.l_name = "ali"
        temp.dob = "1099-05-22"
        temp.roleID = 5
        temp.relatives = []
        return temp
    }
    func Get_S() -> FamilyTree {
        let temp = FamilyTree()
        temp.title = "beta"
        temp.l_name = "ali"
        temp.relatives = []
        return temp
    }
    func Get_D() -> FamilyTree {
        let temp = FamilyTree()
        temp.title = "Baji"
        temp.dob = "1099-05-22"
        temp.l_name = "ali"
        temp.relatives = []
        return temp
    }
    func Get_Fa() -> FamilyTree {
        let temp = FamilyTree()
        temp.title = "Father"
        temp.l_name = "ali"
        temp.dob = "1099-05-22"
        temp.relatives = [getM(),Get_S(),Get_Me(),Get_D(),Get_S()]
        return temp
    }
    
    func getWife() -> FamilyTree {
        let temp = FamilyTree()
        temp.title = "wife"
        temp.l_name = "ali"
        temp.roleID = 5
        temp.dob = "1099-05-22"
        temp.relatives = []
        return temp
    }
    func Get_Me() -> FamilyTree {
        let temp = FamilyTree()
        temp.title = "Me"
        temp.l_name = "ali"
        temp.dob = "1099-05-22"
        temp.relatives = [getWife(),Get_S(),Get_D(),Get_S()]
        return temp
    }
    
    
    
    
    
}
extension UserFamilyTreeViewController{
    
    //////////////////////// GetData Function ?????????/
    func GetData()  {

        self.view.isUserInteractionEnabled = false
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/tree/detail"
                let headers = ["Authorization":"Bearer \(AppDelegate.personalInfo.token)","Accept":"application/json"]
//        print(AppDelegate.personalInfo.token)
//        let headers = ["Authorization":str,"Accept":"application/json"]
        
        Alamofire.request (urlstring ,method : .post, parameters: nil, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                self.view.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success {
                        let obj = FamilyTree()
                        let data = dic["data"]?.dictionary ?? [:]
                        obj.id = data["id"]?.int ?? 0
                        obj.tree_id = data["tree_id"]?.int ?? 0
                        obj.f_name = data["f_name"]?.string ?? ""
                        obj.l_name = data["l_name"]?.string ?? ""
                        obj.email = data["email"]?.string ?? ""
                        obj.gender = data["gender"]?.string ?? ""
                        obj.about = data["about"]?.string ?? ""
                        obj.dob = data["dob"]?.string ?? ""
                        obj.is_alive = data["is_alive"]?.int ?? 0
                        obj.departure_date = data["departure_date"]?.string ?? ""
                        obj.image = data["image"]?.string ?? ""
                        obj.thumbnail = data["thumbnail"]?.string ?? ""
                        obj.level = data["level"]?.int ?? 0
                        obj.created_at = data["created_at"]?.string ?? ""
                        obj.updated_at = data["updated_at"]?.string ?? ""
                        obj.deleted_at = data["deleted_at"]?.string ?? ""
                        obj.roleID = data["role_id"]?.int ?? 0
                        obj.user_id = data["user_id"]?.int ?? -1
                        let arr = data["relatives"]?.array ?? []
                        
                        for item in arr{
                            let dic1 = item.dictionary ?? [:]
                            let res = self.returnRelatives(data: dic1)
                            obj.relatives.append(res)
                        }
                        DispatchQueue.main.async {
                            self.adddata(Data: obj)
                        }
                        
                    }
                    else{
                        SVProgressHUD.dismiss()
                        self.addPoundView()
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    alert3(view: self, msg: error.localizedDescription)
                    print(error.localizedDescription)
                }
        }
    }
    func CreatePound()  {
       
        self.view.isUserInteractionEnabled = false
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/tree/create"
                let headers = ["Authorization":"Bearer \(AppDelegate.personalInfo.token)","Accept":"application/json"]
        
        Alamofire.request (urlstring ,method : .post, parameters: nil, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                self.view.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success {
                        self.CreatePoundView.removeFromSuperview()
                        self.GetData()
                    }
                    else{
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                case .failure(let error):
                    alert3(view: self, msg: error.localizedDescription)
                    print(error.localizedDescription)
                }
        }
    }
    func returnRelatives(data:[String : JSON])->FamilyTree{
        let temp = FamilyTree()
        let dic1 = data
        temp.id = dic1["id"]?.int ?? 0
        temp.tree_id = dic1["tree_id"]?.int ?? 0
        temp.f_name = dic1["f_name"]?.string ?? ""
        temp.l_name = dic1["l_name"]?.string ?? ""
        temp.email = dic1["email"]?.string ?? ""
        temp.gender = dic1["gender"]?.string ?? ""
        temp.about = dic1["about"]?.string ?? ""
        temp.dob = dic1["dob"]?.string ?? ""
        temp.is_alive = dic1["is_alive"]?.int ?? 0
        temp.departure_date = dic1["departure_date"]?.string ?? ""
        temp.image = dic1["image"]?.string ?? ""
        temp.thumbnail = dic1["thumbnail"]?.string ?? ""
        temp.level = dic1["level"]?.int ?? 0
        temp.created_at = dic1["created_at"]?.string ?? ""
        temp.updated_at = dic1["updated_at"]?.string ?? ""
        temp.deleted_at = dic1["deleted_at"]?.string ?? ""
        temp.roleID = dic1["role_id"]?.int ?? 0
        temp.user_id = data["user_id"]?.int ?? -1
        let arr1 = dic1["relatives"]?.array ?? []
        
        if arr1.count == 0{
            print(temp.f_name)
            return temp
        }
        for item in arr1{
            let dic12 = item.dictionary ?? [:]
            let res = returnRelatives(data: dic12)
            temp.relatives.append(res)
        }
        return temp
    }
}
class MyButton: UIButton {
    var node:UIView?
    var data:Any?
    
    override init(frame: CGRect) {
        node = UIView()
        data = FamilyTree()
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        node = UIView()
        data = FamilyTree()
        super.init(coder: aDecoder)
    }
}


