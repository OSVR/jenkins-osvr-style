## Jenkins, OSVR Style
Forked from <https://github.com/isotope11/jenkins-isotope-style> for OSVR.

For use with Jenkins and the [Jenkins Simple Theme Plugin][simple_theme].

### Development
To run sass and compile the stylesheet as you make changes, run this:

    sass --watch jenkins-osvr-style.scss:jenkins-osvr-style.css

Push the generated styles to the GitHub pages branch, `gh-pages`, which is where Jenkins looks for them

[sass]: http://sass-lang.com/
[simple_theme]: https://wiki.jenkins-ci.org/display/JENKINS/Simple+Theme+Plugin
