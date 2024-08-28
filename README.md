## Overview
Project for the Industry 4.0 Laboratory course at the University of Ferrara, which aims to simulate an IT project management system.

Each project is composed of several tasks characterised by labels and has several collaborators as well as a project manager.

## Specifications
- Language: Ruby
- Framework: Rails
- Continuous Integration: automated testing on pull requests
- Continuous Deployment: automated deployment in DockerHub after merging in `main` branch

## How to start the app
1. `bundle install`
2. `npm install`
3. `bundle exec rails db:migrate`
4. `bundle exec rails server`
5. Go to the browser to `localhost:3000`

#### From Docker
1. `docker pull steroma/pma`
2. `docker container run -p 3000:3000 steroma/pma`
3. Go to the browser to `localhost:3000`
