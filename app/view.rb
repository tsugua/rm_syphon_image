class View < NSView
    
  def initWithFrame(rect)
    super
    frame = NSMakeRect(0,0,rect[1][0],rect[1][1])
    @imageView = NSImageView.alloc.initWithFrame(frame)
    @imageView.setImageScaling(NSScaleProportionally)
    @imageView.setImage(NSImage.imageNamed('test_map.png'))
    self.addSubview(@imageView)
  end
  
  def get_imageview
    @imageView
  end
end
