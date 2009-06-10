Rehearsals
==========
*Practice makes permanent.*
--Bobby Robson


What is this?
-------------
Rehearsals is a Sinatra app that lets you run multiple versions of your application simultaneously. 


Uh, why is that a good thing?
------------------------------
Maybe you want to easily play with previous versions of your app or maybe you just want to impress your client with how much work you've done.


What do I need to use it?
-------------------------
You need to be using Sinatra, git, and git tags for your versions.

Your Sinatra app needs to be built in the ["modular" style](http://www.sinatrarb.com/2009/01/18/sinatra-0.9.0.html), an example:

    require 'sinatra/base'

    module YourAppName
      class Application < Sinatra::Base

        set :static, true
        set :public, File.join(File.dirname(__FILE__),'public')
        set :views, File.join(File.dirname(__FILE__),'views')

        get '/' do
          "You gotta love livin', baby, 'cause dyin' is a pain in the ass."
        end

      end
    end

Apps made in the above style still work as standalone Sinatra apps, so you're not committing to anything by building it this way, but you get the added benefit of being able to mount your app as Rack middleware.


How do I use it?
----------------
Just drop in the `rehearsals` directory into the top level of your app, create a config.yml (example provided) with the class name of your application and the file name for your sinatra file, and run it:

    shotgun rehearsals/config/config.ru

or

    thin -R rehearsals/config/config.ru start


Tips
----

  * Don't forget that git tags can take a message:

        git tag tagname -m "Your tag message"
    
    If you don't include one, Rehearsals will show the last commit message instead.

  * If you start your server in development mode, in addition to serving each tag, your HEAD and Master are served. In production these are not shown.

  * If you are using Thin and create a new tag, it won't get picked up. Either restart the server, use [Shotgun](http://rtomayko.github.com/shotgun/), or use the supplied Rake tasks to re-export your tags.

  * Because we are mounting your app at a URL that isn't at the root, you'll need to be mindful of URLs in your HTML. Either use relative paths or a helper method to write your paths. To help with the latter, Rehearsals sets a variable called `site_root` for the URL path to the mounted app.
  
  An example of a helper you could use in your app.
  
        set :site_root, '/'
        def path_to_stylesheet(stylesheet)
          options.site_root + "css/#{stylesheet}.css?"
        end
        
  `:site_root` would get overwritten by Rehearsals so the above helper will work whether your app was run standalone or in Rehearsals.
  
Acknowledgements
----------------
Special thanks to [Tim Lucas](http://toolmantim.com) for basically telling me how this whole thing could work. The cool stuff is his, the mistakes are mine.


The Fine Print
--------------
Copyright (c) 2009 [Phil Oye](http://philoye.com/) and licensed under the [MIT license](http://www.opensource.org/licenses/mit-license.php)