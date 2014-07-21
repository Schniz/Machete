var source = require('vinyl-source-stream');
var gulp = require('gulp');
var gutil = require('gulp-util');
var browserify = require('browserify');
var reactify = require('coffee-reactify');
var watchify = require('watchify');
var notify = require("gulp-notify");
var scriptsDir = './src/client-server';
var buildDir = './public/scripts/common';

var buildExternals = ['react']; 
 
function handleErrors() {
  var args = Array.prototype.slice.call(arguments);
  notify.onError({
    title: "Compile Error",
    message: "<%= error.message %>"
  }).apply(this, args);
  this.emit('end'); // Keep gulp from hanging on this task
}
 
 
// Based on: http://blog.avisi.nl/2014/04/25/how-to-keep-a-fast-build-with-browserify-and-reactjs/
function buildScript(file, watch, externals) {
  var props = {
    entries: [scriptsDir + '/' + file],
    transform: ['coffee-reactify'],
    extensions: ['cjsx']
  };

  var bundler = watch ? watchify(props) : browserify(props);

  var externalOrRequire = externals ? bundler.require : bundler.external;
  buildExternals.forEach(function(buildExternal) {
    externalOrRequire.call(bundler, buildExternal);
  });

  bundler.transform(reactify);
  
  function rebundle() {
    var stream = bundler.bundle({debug: true});
    return stream.on('error', handleErrors).pipe(source(file)).pipe(gulp.dest(buildDir + '/'));
  }

  bundler.on('update', function() {
    rebundle();
    gutil.log('Rebundle ' + file + '...');
  });
  return rebundle();
}
 
gulp.task('build:cjsx', function() {
  return buildScript('client.cjsx', false);
}).task('build:lib', function() {
  buildScript("lib.js", false, true);
}).task('build', ['build:lib', 'build:cjsx'], function() {
}).task('build:watch', ['build'], function() {
  return buildScript('client.cjsx', true);
});