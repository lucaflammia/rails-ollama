# README

Here you find a Ruby on Rails frontend/middle-tier that will talk to several open-source AI LLMs. All of this will let you mimic what the ChatGPT website does.

This code will:

- Let you create/manage users by hooking in Devise
- Let you create conversations with LLMs that are assigned to a user
- Let you save and retrieve these conversations so that they can be continued at any time.


# Get Started

Before running the app, we need to set up the database for recording conversations. 

Using the docker-compose we can set up Redis and Postgres. Therefore

```docker-compose up -d```

Finally, we can run the server

```rails s```