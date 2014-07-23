var Stream = require("stream");
var source = require('vinyl-source-stream');
var gulp = require('gulp');
var rename = require('gulp-rename');
var gutil = require('gulp-util');
var browserify = require('browserify');
var reactify = require('coffee-reactify');
var watchify = require('watchify');
var notify = require("gulp-notify");
var scriptsDir = './src/client-server';
var buildDir = './public/scripts/common';
var packageJson = require(__dirname + '/../package.json');
var sass = require('gulp-sass');
var prefix = require('gulp-autoprefixer');

var gulpConfig = packageJson.gulp.config;
var transformToJsRegex = RegExp(".(" + gulpConfig.transformToJsExtension.join('|') + ")$");

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
  gulpConfig.buildExternals.forEach(function(buildExternal) {
    externalOrRequire.call(bundler, buildExternal);
  });

  bundler.transform(reactify);
  
  function rebundle() {
    var stream = bundler.bundle({debug: true}).on('error', handleErrors).pipe(source(file));

    if (file.match(transformToJsRegex)) {
      stream = stream.pipe(rename({ extname: '.js' }));
    }

    return stream.pipe(gulp.dest(buildDir + '/'));
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
  return buildScript("lib.js", false, true);
}).task('build:sass', function() {
  return gulp.src('./src/sass/**/main.scss')
    .pipe(sass()).on('error', handleErrors)
    .pipe(prefix("last 1 version", "> 1%", "ie 8", "ie 7"))
    .pipe(gulp.dest('./public/style/'));
}).task('build', ['build:lib', 'build:cjsx', 'build:sass'], function() {
}).task('build:watch', ['build'], function() {
  gulp.watch('./src/sass/**/*', ['build:sass']);
  gulp.watch('./src/client-server/**/*', ['build:cjsx']);
  gulp.watch('./src/client-server/**/*', ['build:lib']);
  return buildScript('client.cjsx', false);
});