# Getting Started using Docker

Application Setup Requires 4 Steps

1. Clone repository to your Machine
2. Setup .env file
3. Run docker compose up
4. Enter Rails container and manually install Gems (currently a work around)

Important note: when running `rails generate` rails creates files by a custom user,
you won't have access to edit the file outside the container. When using the
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

The rails container doesn't like installing gems from the dockerfile
so you need to enter the container and install the gems manually.

Enter the container `docker exec -it rails /bin/bash`

Install gems `bundler install`

# How to connect to Postgres

To connect to postgres, locate the User, Password and IP in the .env file and use this command

`psql <Database> -h <IP> -U <User> -W <Password>`
