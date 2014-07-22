var gulp = require('gulp');
var nodemon = require('gulp-nodemon');
var cjsx = require('gulp-cjsx');
var browserify = require('browserify');
var watchify = require('watchify');
var reactify = require('coffee-reactify')
var gulpJson = require('./package.json').gulp;

// Load the tasks
gulpJson.tasks.forEach(function(task) {
  require("./tasks/" + task);
});

gulp.task('default', ['build', 'run'], function() {
}).task('run', ['build:watch'], function() {
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