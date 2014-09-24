module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    watch:
      coffee:
        files: ['coffee/**/*.coffee']
        tasks: ['newer:coffee']
      scss:
        files: ['scss/**/*.scss']
        tasks: ['build_scss']
      livereload:
        options:
          livereload: true
        files: [
          'public/js/**/*.js'
          'public/css/**/*.css'
          'public/index.html'
        ]

    coffee:
      options:
        bare: true
      src:
        expand: true
        cwd: 'coffee'
        src: ['**/*.coffee']
        dest: 'public/js'
        ext: '.js'

    sass:
      website:
        options:
          style: 'expanded'
        src: 'scss/website.scss'
        dest: 'public/css/website.css'

    bower:
      install:
        options:
          install: true
          copy: false
          cleanTargetDir: false
          cleanBowerDir: false

    copy:
      bootstrap_css:
        files:
         'scss/bootstrap.scss':'bower_components/bootstrap/dist/css/bootstrap.css'
         'scss/bootstrap-theme.scss':'bower_components/bootstrap/dist/css/bootstrap-theme.css'
      bootstrap_fonts:
        expand: true
        cwd: 'bower_components/bootstrap/dist/fonts'
        src: '*'
        dest: 'public/fonts/'
      js:
        expand: true
        flatten: true
        cwd: 'bower_components'
        src: [
          'bootstrap/dist/js/bootstrap.js'
          'jquery/dist/jquery.js'
          'html5shiv/dist/html5shiv.js'
          'handlebars/handlebars.js'
          'ember/ember.js'
          'momentjs/moment.js'
        ]
        dest: 'public/js/vendor/'

    clean:
      public:
        src: [
          'public/css'
          'public/js'
          'public/fonts'
          'compiled/**/*'
        ]

  require('load-grunt-tasks') grunt

  grunt.registerTask 'start_web_server', ->
    grunt.log.writeln('Started web server on port 3000');
    require('./server').listen(3000)

  grunt.registerTask 'build_scss', ['sass']

  grunt.registerTask 'build_coffee', ['coffee']

  grunt.registerTask 'build', [
    'bower:install'
    'copy'
    'build_scss'
    'build_coffee'
  ]

  grunt.registerTask 'default', [
    'start_web_server'
    'watch'
  ]