Rehearsals
==========
Rehearsals is a Sinatra application that lets you run multiple versions (actually your tags in git) of your application simultaneously. 

Just drop in the `rehearsals` directory into the top level of your app, create a config.yml with the class name of your application and the file name for your sinatra file (example provided), and run it.

    shotgun rehearsals/config/config.ru

Don't forget that git tags can take a message:

    git tag tagname -m "Your tag message"
    
TODO:
  *  We should grab the latest commit message for master.