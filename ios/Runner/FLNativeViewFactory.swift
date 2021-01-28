import Flutter
import UIKit
import AVKit

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
      print("given view size: \(frame)")
      _view = FLEmbedView()
      _view.backgroundColor = UIColor.blue
      super.init()
    }

    func view() -> UIView {
        return _view
    }
}

class FLEmbedView : UIView {
  var _nativeLabel:UILabel?
  var _avPlayer:AVPlayer?
  var _avLayer:AVPlayerLayer?
  
  func _initSubViews() {
    
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    _nativeLabel = UILabel()
    _nativeLabel?.text = "Native text from iOS"
    _nativeLabel?.textColor = UIColor.white
    _nativeLabel?.backgroundColor = UIColor.red
    _nativeLabel?.textAlignment = .center
    _nativeLabel?.frame = CGRect.zero
    
    let path = Bundle.main.url(forResource: "demo", withExtension: "mov")
    
    let asset = AVURLAsset(url: path!)
    let item = AVPlayerItem(asset: asset)
    print("\(String(describing: path))")
    _avPlayer = AVPlayer(playerItem: item)
    print("\(String(describing: _avPlayer))")
    _avLayer = AVPlayerLayer(player: _avPlayer!)
    print("\(String(describing: _avLayer))")
    _avLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill

    
    self.layer.addSublayer(_avLayer!)
    self.addSubview(_nativeLabel!)
    
    _avPlayer?.play()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func layoutSubviews() {
    print("current frame: \(self.frame)")
    _avLayer?.frame = self.bounds
    _nativeLabel?.frame = CGRect(x: 10, y: 10, width: self.bounds.width-20, height: 28)
    super.layoutSubviews()
  }
}
