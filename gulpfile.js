var gulp = require('gulp');
var nodemon = require('gulp-nodemon');
var cjsx = require('gulp-cjsx');
var browserify = require('browserify');
var watchify = require('watchify');
var reactify = require('coffee-reactify')

var buildTask = require('./tasks/build');

gulp.task('default', ['build', 'run'], function() {
}).task('run', ['build'], function() {
  require(__dirname + '/index');
}).task('watch', ['build:watch'], function() {
  return nodemon({
    script: 'index.js',
    ext: 'js',
    ignore: ['./public/**'] 
  }).on('restart', function () {
    console.log('restarted!')
  });
});