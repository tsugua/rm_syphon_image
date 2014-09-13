# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require "motion/project/template/osx"

begin
  require "bundler"
  Bundler.require
rescue LoadError
end
require 'bubble-wrap/all'


Motion::Project::App.setup do |app|
  app.name = "Frames"
  app.frameworks += ["OpenGL"] 
  app.frameworks << "GLKit"
  app.embedded_frameworks << "vendor/Syphon.framework"
  app.vendor_project("vendor/ServerEOS", :xcode, :target => "ServerEOS", :products => ["libServerEOS.a"])
  app.bridgesupport_files << "vendor/ServerEOS/ServerEOS/BridgeSupport.bridgesupport"
  app.info_plist['LSAppNapIsDisabled'] = 'true'
end
