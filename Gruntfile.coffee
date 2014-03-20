module.exports = (grunt) ->
    # Project configuration.
    grunt.initConfig
        pkg: grunt.file.readJSON("package.json")
        meta:
            banner: '/*!\n' +
                'Picturebook\n' +
                '@name picturebook\n' +
                '@author Alexander van Trijffel (@avtnl)\n' +
                '@version <%= pkg.version %>\n' +
                '@date <%= grunt.template.today("yyyy-mm-dd") %>\n' +
                '*/\n'
        notify:
            coffee:
                options:
                    title: 'grunt'
                    message: 'Compiled coffeescript'
            jade:
                options:
                    title: 'grunt'
                    message: 'Compiled jade'
            sass:
                options:
                    title: 'grunt'
                    message: 'Compiled sass'

        watch:
            css: {
                files: 'pub/**/*.css',
                options: {
                    livereload: true
                }
            }
            js: {
                files: 'pub/**/*.js',
                options: {
                    livereload: true
                }
            }
            html: {
                files: '**/*.html',
                options: {
                    livereload: true
                }
            }
            coffee:
                files: 'src/coffee/**/*.coffee',
                tasks: ['coffee:compile', 'notify:coffee']
            jade:
                files: 'src/jade/**/*.jade'
                tasks: ['jade:compile', 'notify:jade']
            sass:
                files: 'src/scss/**/*.scss'
                tasks: ['sass:compile', 'notify:sass']

        coffee:
            compile:
                options:
                    bare: true
                files:
                    'pub/scripts/picturebook.js': ['src/coffee/*.coffee']

        jade:
            compile:
                options:
                    data:
                        debug: true
                files:
                    "index.html": "src/jade/index.jade"

        sass:
            compile:
                files:
                    'pub/styles/main.css': 'src/scss/main.scss'
        cssmin:
            minify:
                expand: true,
                cwd: '',
                src: ['*.css', '!*.min.css'],
                dest: '',
                ext: '.min.css'

        uglify:
            dist:
                options:
                    banner: "<%= meta.banner %>"
                files:
                    "pub/scripts/picturebook.js" : ['pub/scripts/picturebook.js']

    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-contrib-jade"
    grunt.loadNpmTasks "grunt-contrib-coffee"
    grunt.loadNpmTasks "grunt-sass"
    grunt.loadNpmTasks "grunt-contrib-cssmin"
    grunt.loadNpmTasks "grunt-contrib-uglify"
    grunt.loadNpmTasks 'grunt-notify'

    grunt.registerTask 'default', ['watch']
    grunt.registerTask "release", [
        "jade"
        "coffee"
        "sass"
        "cssmin"
        "uglify"
    ]