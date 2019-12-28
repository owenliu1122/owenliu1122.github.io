FROM jekyll/jekyll:latest

RUN gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/

COPY ./ /srv/jekyll

RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.com

RUN cd /srv/jekyll && bundle install

# this should start three processes, mysql and ssh
# in the background and node app in foreground
# isn't it beautifully terrible? <3
CMD bundle exec jekyll server
