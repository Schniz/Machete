var gulp = require('gulp');
var nodemon = require('gulp-nodemon');

gulp.task('watch', ['build:watch'], function() {
  return nodemon({
    script: 'index.js',
    ext: 'js',
    ignore: ['./public/**'] 
  }).on('restart', function () {
    console.log('restarted!')
  });
});