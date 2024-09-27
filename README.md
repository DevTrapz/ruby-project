# Getting Started using Docker

Application Setup Requires 5 Steps

1. Clone repository to your Machine
2. Setup .env file
3. Run docker compose up
4. Enter Rails container then manually install Gems and initalize database
   (currently a work around)

Important note: when running `rails generate` rails creates files by a custom
user, you won't have access to edit the file outside the container. When using the
`rails generate` add permissions to all users to read/write the directories files
`sudo chmod -R a+rw ./rails`. This is just a work around for now.

# Step 1 - Clone Repository to your Machine

Run `git clone https://github.com/DevTrapz/ruby-project.git`

# Step 2 - Setup .env file

The .env file require declarations for

`POSTGRES_USER`
`POSTGRES_PASSWORD`
`RAILS_PORT`

# Step 3 - Run docker compose

Run `docker compose up --build -d` to build images and run in detached mode

# Step 4 - Enter Rails container and manually install Gems

The rails container doesn't like installing gems or initalizing the database
from the dockerfileso you need to enter the container and install the gems
manually. Follow this sequence

1. Enter the container `docker exec -it rails /bin/bash`
2. Install gems `bundler install`
3. Initialize database `rake db:create` and `rails db:migrate`

# How to connect to Postgres

To connect to postgres, locate the User, Password and IP in the .env file and use this command

`psql <Database> -h <IP> -U <User> -W <Password>`

# Fix newly created file permissions on host (only for linux host)

When creating files on the host, that the container volume is mounted, you'll
need to grant file permission to edit the file from the container. Execute this
command on the host to grant all users (including the container) to have access
to read and write.

`sudo chmod a+rw <file path>` or for entire directory `sudo chmod -R a+rw <directory path>`

You can set default permissions on the host user, so that whenever you create a file
all users (including the container) can edit the file.

Use this command with caution! Since it defaults permissions on newly created files
to all users, it will remain that when until you change it. This goes against security
best practices of least-privilege. Ideally you would use a dedicated linux user when
working on this project, then grant that user the default permissions.

`umask 000`
