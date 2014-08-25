class AppDelegate
  def applicationDidFinishLaunching(notification)
    @pos_x = 240
    @pos_y = 180
    @width = 480
    @height = 360
    
    buildMenu
    buildWindow

    start_timer    
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[@pos_x, @pos_y], [@width, @height]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary["CFBundleName"]
    @mainWindow.orderFrontRegardless
    @mainWindow.setContentView view
  end

  def view
    @view ||= View.alloc.initWithFrame(@mainWindow.frame)
  end

  def start_timer
    timer = EM.add_periodic_timer 0.001 do
      # NSThread.detachNewThreadSelector('publish', toTarget: self, withObject: nil)  
      publish
   end
  end
  
  def save_image
    bitmap =  @view.bitmapImageRepForCachingDisplayInRect(@view.visibleRect)
    @view.cacheDisplayInRect(@view.visibleRect, toBitmapImageRep:bitmap)

	  representation = bitmap.representationUsingType(NSJPEGFileType, properties:nil)
    representation.writeToFile("TEST_FILE.jpg", atomically:true)
  end
  
  def publish
    
		attrs			  = Pointer.new_with_type('I', 11)
		attrs[0]		= NSOpenGLPFADoubleBuffer
		attrs[1]		= NSOpenGLPFAAccelerated
		attrs[2]		= NSOpenGLPFADepthSize
		attrs[3]		= 24
		attrs[4]		= NSOpenGLPFAMultisample
		attrs[5]		= NSOpenGLPFASampleBuffers
		attrs[6]		= NSOpenGLPFAColorSize
		attrs[7]		= 1
		attrs[8]		= NSOpenGLPFASamples
		attrs[9]		= 4
		attrs[10]	  = 0

    
    pf = NSOpenGLPixelFormat.alloc.initWithAttributes(attrs)
    
    #this doesn't work because we haven't validated the pixel format... Do we need to do this?
    # unless pf
    #   p "Could not create pixel format, falling back to simpler pixel format"
    #
    #       simpleattr      = Pointer.new_with_type('I', 3)
    #       simpleattr[0]    = NSOpenGLPFADoubleBuffer
    #       simpleattr[1]    = NSOpenGLPFAAccelerated
    #       simpleattr[2]    = 0
    #
    #   pf = NSOpenGLPixelFormat.alloc.initWithAttributes(simpleattr)
    # end
    #
    # p "pf is #{pf}"
    # unless pf
    #     p "Could not create pixel format, bailing"
    #     # NSApp.terminate(self)
    # end
    
    glContext = NSOpenGLContext.alloc.initWithFormat(pf, shareContext:nil)
    glContext.makeCurrentContext

    @syphonServer = ServerEOS.alloc.createSyphonServer("test", withContext: glContext) unless @syphonServer

    @imageView = @view.get_imageview
    anImage = @imageView.image
    # save_image
    
    bitsPerComponent = 8
    componentsPerPixel = 4
    bytesPerRow =((bitsPerComponent * @imageView.image.size.width) / 8) * componentsPerPixel
    colorSpace = CGColorSpaceCreateDeviceRGB()
    
    # p "image size:  #{anImage.size.width}, #{anImage.size.height}"
    
    
    imageRep = NSBitmapImageRep.alloc.initWithData(anImage.TIFFRepresentation)
    pixelData = imageRep.CGImage
    
    gtx = CGBitmapContextCreate(nil, anImage.size.width, anImage.size.height, bitsPerComponent, bytesPerRow, colorSpace, KCGImageAlphaPremultipliedLast)
    
    CGContextDrawImage(gtx, CGRectMake(0, 0, 1132, 994), pixelData)
    CGContextFlush(gtx)

    texture = GLKTextureLoader.textureWithCGImage(pixelData, options:nil, error:nil)

    # p "texture: #{texture.name}, #{texture.width}, #{texture.height}"
    
    if @syphonServer.hasClients
      @syphonServer.publishFrameTexture(texture.name,
                        textureTarget: GL_TEXTURE_2D,
                          imageRegion: NSMakeRect(0, 0, texture.width, texture.height),
                    textureDimensions: NSMakeSize(texture.width, texture.height),
                              flipped: true)
    end
  end
end
