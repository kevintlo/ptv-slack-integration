# API Integration Project for PTV / Slack

A simple integration project to alert public transport users when their train line has disrupted service.

Project includes:

* Extraction of route disruption information from Public Transport Victoria API

* Information is being utilized to altert any person affected by the disruption by posting a Slack message to them

# API Credentials

To successfully run the application a secrets.yml file needs to exist including your unique API credentials. The environment variables are being accessed through Rails.application.secrets.API_KEY 
