Rehearsals
==========
Rehearsals is a Sinatra application that lets you run multiple versions (actually your tags in git) of your application simultaneously. 

Just drop in `rehearsals` into your app, change all references to "Projectname" with your application class, change "projectname.rb" with your program's filename, and run it:

    cd rehearsals
    shotgun


Don't forget that git tags can take a message:

    git tag tagname -m "Your tag message"
    
TODO:
  *  Move your application filename/class name into a yml file rather than making people hack files.
  *  We should grab the latest commit message for master.