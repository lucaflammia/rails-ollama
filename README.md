# README

Here you find a Ruby on Rails frontend/middle-tier that will talk to several open-source AI LLMs. All of this will let you mimic what the ChatGPT website does.

This code will:

- Let you create/manage users by hooking in Devise
- Let you create conversations with LLMs that are assigned to a user
- Let you save and retrieve these conversations so that they can be continued at any time.


# Get Started

Before running the app, we need to connect the database for recording conversations. 

To this purpose we need to define settings with the ```.env``` file

e.g.

```
PORT=3000
REDIS_PORT=16679
REDIS_URL=redis://localhost:16679
POSTGRES_HOST=localhost
POSTGRES_PORT=28453
POSTGRES_DBUSER=postgres
POSTGRES_PASSWORD=greatpassword
OLLAMA_API_URL=http://localhost:11434
```

Using the docker-compose we can set up Redis and Postgres. 

```docker-compose up -d```

Finally, run the server

```rails s```