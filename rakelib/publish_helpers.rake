
## Publish stuff

# Based on https://github.com/neo/middleman-gh-pages/blob/master/lib/middleman-gh-pages/tasks/gh-pages.rake
# MIT license, see adjacent file.
require 'fileutils'
require 'pp'

def remote_name
  ENV.fetch("REMOTE_NAME", "origin")
end

REPO_ROOT = `git rev-parse --show-toplevel`.strip
PUBLISH_DIR    = File.join(REPO_ROOT, "_publish")
GH_PAGES_REF = File.join(PUBLISH_DIR, ".git/refs/remotes/#{remote_name}/gh-pages")

directory PUBLISH_DIR
CLEAN << PUBLISH_DIR

file GH_PAGES_REF => PUBLISH_DIR do
  repo_url = nil

  cd REPO_ROOT do
    repo_url = `git config --get remote.#{remote_name}.url`.strip
  end

  cd PUBLISH_DIR do
    sh "git init"
    sh "git remote add #{remote_name} #{repo_url}"
    sh "git fetch #{remote_name}"

    if `git branch -r` =~ /gh-pages/
      sh "git checkout gh-pages"
    else
      sh "git checkout --orphan gh-pages"
      touch "index.html"
      sh "git add ."
      sh "git commit -m 'initial gh-pages commit'"
      sh "git push #{remote_name} gh-pages"
    end
  end
end

namespace :publishing do
  # Alias to something meaningful
  task :prepare_git_remote => GH_PAGES_REF

  # Prevent accidental publishing before committing changes
  task :not_dirty do
    puts "***#{ENV['ALLOW_DIRTY']}***"
    unless ENV['ALLOW_DIRTY']
      fail "Directory not clean: commit or stash your changes!" if /nothing to commit/ !~ `git status`
    end
  end

  # Set up the publish directory as empty, but at the tip of the correct branch.
  task :reset_dir => :prepare_git_remote do
    puts "\n## Preparing for publish\n"
    cd PUBLISH_DIR do
      # Get the latest upstream revision, and forcibly switch to it.
      sh "git fetch #{remote_name}"
      sh "git symbolic-ref HEAD refs/heads/gh-pages"
      sh "git reset --hard #{remote_name}/gh-pages"

      # Delete untracked and ignored files
      sh "git clean -fdx"

      # Delete files git knows about.
      `git ls-files`.split("\n").each do |fn|
        rm fn.strip
      end

      # Needed as a dummy file.
      touch "index.html"
    end
  end

  #desc "Copy and publish updated version to GitHub pages"
  task :publish, [:dir] => [:not_dirty, :reset_dir] do |t, args|
    src_dir = args.dir
    raise "Missing argument :dir to task #{t.name}" unless src_dir

    puts "\n## Composing commit message\n"
    message = nil
    cd REPO_ROOT do
      head = `git log --pretty="%h" -n1`.strip
      message = "Site updated to #{head}"
    end

    puts "\n## Copying files to publish\n"
    # Copy files from given directory into publish directory
    FileList.new("#{src_dir}/*").each do |item|
      target = item.sub(src_dir, PUBLISH_DIR)
      cp item, target, :verbose => true
    end

    puts "\n## Adding, committing, and pushing\n"
    cd PUBLISH_DIR do
      # Add all new files, commit, and push.
      sh "git add --all"
      if /nothing to commit/ =~ `git status`
        puts "No changes to commit."
      else
        sh "git commit -m \"#{message}\""
      end
      sh "git push #{remote_name} gh-pages"
    end

  end

end
