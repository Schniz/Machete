var gulp = require('gulp');
var shell = require('gulp-shell');

gulp.task('install', shell.task([
  "npm install",
  "bower install",
  "gulp build"
]));