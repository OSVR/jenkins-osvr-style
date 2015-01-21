## Jenkins, OSVR Style
Forked from <https://github.com/isotope11/jenkins-isotope-style> for OSVR.

For use with Jenkins and the [Jenkins Simple Theme Plugin][simple_theme].

### Development
To run sass and compile the stylesheet as you make changes, run this:

    sass --watch jenkins-osvr-style.scss:jenkins-osvr-style.css

To push the styles to GitHub pages, which is where Jenkins looks for them, make
sure you've committed and pushed everything to master.  Then run:

    ruby copy_styles.rb

That'll do all the git magic.  Now when you ctrl+refresh Jenkins, your changes
are there.

[sass]: http://sass-lang.com/
[simple_theme]: https://wiki.jenkins-ci.org/display/JENKINS/Simple+Theme+Plugin
