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
            livereload: {
                options:
                    livereload: true
                files: ["pub/**/*"]
            }
            coffee:
                files: 'src/coffee/**/*.coffee',
                tasks: ['coffee:compile', 'uglify:jsdev', 'notify:coffee']
            jade:
                files: 'src/jade/**/*.jade'
                tasks: ['jade:compile', 'notify:jade']
            sass:
                files: 'src/scss/**/*.scss'
                tasks: ['sass:compile', 'notify:sass']
            css:
                files: 'pub/styles/**/*.css'
                tasks: ['cssmin:minify']

        coffee:
            compile:
                options:
                    bare: true
                    sourceMap: true
                expand: true
                cwd: "src/coffee/"
                src: ["**/*.coffee"]
                dest: "pub/scripts/uncompressed/"
                ext: ".js"
                
        jade:
            compile:
                options:
                    data:
                        debug: true
                files:
                    "pub/index.html": "src/jade/index.jade"
                    "pub/start.html": "src/jade/start.jade"

        sass:
            compile:
                files:
                    'pub/styles/main.css': 'src/scss/main.scss'
        cssmin:
            minify:
                expand: true,
                cwd: 'pub/styles/',
                src: ['**/*.css', '!**/*.min.css'],
                dest: 'pub/styles/',
                ext: '.min.css'

        uglify:
            dist:
                options:
                    compress:
                        drop_console: true
                files:
                    "pub/scripts/picturebook.min.js": [
                        "pub/scripts/uncompressed/*.js"
                        "pub/scripts/uncompressed/constants/*.js"
                        "pub/scripts/uncompressed/factories/*.js"
                        "pub/scripts/uncompressed/directives/*.js"
                        "pub/scripts/uncompressed/controllers/*.js"                        
                    ]
            jsdev: 
                options:
                    compress: false
                    #beautify: true
                    mangle: false
                files:
                    'pub/scripts/picturebook.min.js': [
                        "pub/scripts/uncompressed/*.js"
                        "pub/scripts/uncompressed/constants/*.js"
                        "pub/scripts/uncompressed/factories/*.js"
                        "pub/scripts/uncompressed/directives/*.js"
                        "pub/scripts/uncompressed/controllers/*.js"
                    ]
            # dynamic_mappings: 
            #     expand: true,
            #     cwd: "pub/scripts/app"
            #     src: ["**/*.js", '!*.min.js']
            #     dest: "pub/scripts/app"
            #     ext: '.min.js'

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