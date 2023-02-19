//
//  ViewController.swift
//  aod
//
//  Created by 윤태경 on 2023/02/15.
//

import UIKit
import CoreText

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var picButton: UIButton!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var imagePickerController = UIImagePickerController()
    var backgroundImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // 날짜(dateLabel)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        
        // 시간(myLabel)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            let date = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm"
            let timeString = timeFormatter.string(from: date)
            self.myLabel.text = timeString
            
            
        }
        // 저장된 폰트 로드
        if let selectedFontName = UserDefaults.standard.string(forKey: "selectedFontKey") {
            let selectedFont = UIFont(name: selectedFontName, size: 100.0)!
            myLabel.font = selectedFont
        }
        
        // 저장된 이미지 로드
        if let imageData = UserDefaults.standard.data(forKey: "selectedImageKey") {
            let image = UIImage(data: imageData)
            myImageView.image = image
            self.myImageView.contentMode = .scaleAspectFill
            self.myImageView.alpha = 1
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.myImageView.alpha = 0.25
            }, completion: nil)
        }
        
        
        // datelabel 업데이트
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        self.dateLabel.text = dateString
        
        //이미지 피커 가져오기
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true //false로 하면 이미지가 저장이 안되고 true로 하면 이미지가 9:16으로 잘라지게 나와야 되는 데 계속 1:1로 나오고 근데 이미지 저장은 잘됨
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap))
        myLabel.isUserInteractionEnabled = true
        myLabel.addGestureRecognizer(tapGesture)
        
        
        
    }
    // 폰트 피커
    @objc func handleLabelTap(sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "폰트 선택", message: nil, preferredStyle: .actionSheet)
        
        let fontNames = UIFont.familyNames.sorted()
        for fontName in fontNames {
            let font = UIFont(name: fontName, size: 100.0)!
            let action = UIAlertAction(title: fontName, style: .default) { (action) in
                UserDefaults.standard.set(fontName, forKey: "selectedFontKey")
                self.myLabel.font = font
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = myLabel
            popoverController.sourceRect = myLabel.bounds
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    //picButton 이 눌리면 화면이 밝아졌다가 어두워짐
    var timer: Timer?
    
    @IBAction func picButtonTapped(_ sender: Any) {
            let tapGesture = sender as? UITapGestureRecognizer
            if tapGesture?.numberOfTouches == 2 {
                
            } else {
                if timer == nil {
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
                        self.timer = nil
                    })
                } else {
                    timer?.invalidate()
                    timer = nil
                    UIView.animate(withDuration: 0.5, animations: {
                        self.myImageView.alpha = 1.0
                    }, completion: { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 7, execute: {
                            UIView.animate(withDuration: 0.5) {
                                self.myImageView.alpha = 0.25
                            }
                        })
                    })
                }
            }
        }

    
    
    
    @IBAction func picPickButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true // 이미지 편집 가능하도록 설정
        imagePicker.sourceType = .photoLibrary // 앨범에서 이미지 선택
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        myImageView.image = selectedImage // 선택된 이미지를 myImageView에 입힘
        
        // 이미지 애니메이션 설정
        UIView.animate(withDuration: 0.5, animations: {
            self.myImageView.alpha = 1.0
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
                UIView.animate(withDuration: 0.5) {
                    self.myImageView.alpha = 0.25
                }
            })
        })
        
        // 선택된 이미지를 UserDefaults에 저장
        if let imageData = selectedImage.pngData() {
            UserDefaults.standard.set(imageData, forKey: "selectedImageKey")
        }
        
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

        
        
        
        
        
        // 상단바 숨기기(StatusBar)
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        override var prefersStatusBarHidden: Bool {
            return true
        }
    }

