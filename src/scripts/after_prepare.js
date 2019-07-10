#!/usr/bin/env node

var fs = require("fs")
var os = require("os")
var execSync = require('child_process').execSync

var stdio = {stdio:[0,1,2]};

module.exports = function (context) {

  var rootPath = context.opts.projectRoot
  var platformPath = rootPath + "/platforms/android"
  var propertiesPath = platformPath + "/gradle.properties"

  if (!existsFile(propertiesPath)) {
    execSync("touch " + propertiesPath, stdio);
  }

  var text = fs.readFileSync(propertiesPath, "utf-8")
  if (text.match(/android\.enableD8\.desugaring/) == null) {
    if (text.length == 0) {
      text = "android.enableD8.desugaring=true"
    } else {
      text = text + os.EOL + "android.enableD8.desugaring=true"
    }
    fs.writeFileSync(propertiesPath, text)
  }

  function existsFile(path) {
    try {
      fs.statSync(path)
      return true
    } catch(err) {
      return false
    }
  }

  
}
