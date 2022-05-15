FROM gitpod/workspace-postgres

# Install Ruby
ENV RUBY_VERSION=2.7.1

# Install the GitHub CLI
RUN brew install gh

# Install Starship
RUN brew install starship
RUN echo eval "$(starship init bash)" >> ~/.bashrc

# Install heroku
RUN brew tap heroku/brew && brew install heroku

# Install Ruby on Rails
RUN printf "rvm_gems_path=/home/gitpod/.rvm\n" > ~/.rvmrc \
    && bash -lc "rvm reinstall ruby-$RUBY_VERSION && rvm use ruby-$RUBY_VERSION --default \
    && gem install rails && gem install solargraph && gem install ruby-debug-ide && gem install debase" \
    && printf "rvm_gems_path=/workspace/.rvm" > ~/.rvmrc \
    && printf '{ rvm use $(rvm current); } >/dev/null 2>&1\n' >> "$HOME/.bashrc.d/70-ruby"
ENV GEM_HOME=/workspace/.rvm
ENV GEM_PATH=$GEM_HOME:$GEM_PATH
ENV PATH=/workspace/.rvm/bin:$PATH

# Install Redis.
RUN sudo apt-get update \
        && sudo apt-get install -y \
        redis-server netcat \
        && sudo rm -rf /var/lib/apt/lists/*