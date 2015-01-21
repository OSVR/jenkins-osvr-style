## Jenkins, OSVR Style
Forked from <https://github.com/isotope11/jenkins-isotope-style> for OSVR, and heavily modified.

For use with Jenkins and the [Jenkins Simple Theme Plugin][simple_theme].

### Development
To get Bundler rolling, run:

    rake bundle

To run a one-off build for dev mode, run:

    rake dev

To run dev builds and compile the stylesheet as you make changes, with a local web server, run this:

    rake watch

To push the styles to GitHub pages, which is where Jenkins looks for them, make
sure you've committed and pushed everything to master.  Then run:

    rake publish

That'll do all the git magic.  Now when you ctrl+refresh Jenkins, your changes
are there.

### Dev/Publish Dependencies

The following things are required to develop/publish to GitHub Pages (not needed on your Jenkins server, unless it is also in charge of publishing this repo...):

- `ruby` (and `gem`)
- `rake`
- `bundler`

On a recent Debian/Ubuntu, something like

```sh
sudo apt-get install --no-install-recommends rake bundler ruby-dev
```

should get the job done.

[sass]: http://sass-lang.com/
[simple_theme]: https://wiki.jenkins-ci.org/display/JENKINS/Simple+Theme+Plugin
