FROM jekyll/jekyll:pages
COPY ./ /srv/jekyll

RUN cd /srv/jekyll && bundle update

# this should start three processes, mysql and ssh
# in the background and node app in foreground
# isn't it beautifully terrible? <3
CMD bundle exec jekyll server
