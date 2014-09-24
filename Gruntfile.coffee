module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    uglify:
      options:
        mangle: false,
        preserveComments: false,
        report: "min",
        compress:
          hoist_funs: false,
          loops: false,
          unused: false
      applications:
        files:
         'public/js/application.min.js': 'public/js/application.js'

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
      expanded:
        options:
          style: 'expanded'
        src: 'scss/website.scss'
        dest: 'public/css/website.css'

      compressed:
        options:
          style: 'compressed'
        src: 'scss/website.scss'
        dest: 'public/css/website.min.css'

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
          'jquery/dist/jquery.min.js'
          'html5shiv/dist/html5shiv.min.js'
          'handlebars/handlebars.min.js'
          'ember/ember.min.js'
          'momentjs/min/moment.min.js'
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

  grunt.registerTask 'build_coffee', [
    'coffee'
    'uglify'
  ]

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