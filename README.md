# World of Warcraft Audit
This is the back-end scraper engine that generates CSV files for the World of Warcraft Audit Spreadsheet,
found at https://wowaudit.com. The code is open-source and while it's possible for you to play around with,
it's not built with individual use in mind. Therefore, setting up the scripts can be difficult.

## Getting Started

1. Install dependencies (provided Ruby and Bundler are installed):

        $ bundle install

2. Enter the various credentials (and remove `template` from the file names):

        Enter your SQL credentials in `config/database.yml`
        Enter your ArangoDB credentials in `config/arangodb.yml`

        In `config/keys.yml`:
        $ bnet_client_id: <your battle.net client ID>
        $ bnet_client_secret: <your battle.net client secret>
        $ wcl_key: <your Warcraft Logs API key>

        The generated CSV files will be uploaded to a S3 server that you configure, so they can be
        easily fetched by the spreadsheet. In `config/storage.yml` you can enter your S3 credentials.

3. Initialise the database:

        $ rake db:schema:load

4. Run the script locally:

        First, add a guild, team and characters to the database. Currently this
        has to be done manually. Then, run:
        $ bundle exec ruby bin/refresh_bnet_local.rb <TEAM_ID>
        
        To add Warcraft Logs and Raider.io data to your team, the following scripts
        can be run in the same way as refresh_bnet_local:
        $ bundle exec ruby bin/refresh_wcl_local.rb <TEAM_ID>
        $ bundle exec ruby bin/refresh_raiderio_local.rb <TEAM_ID>
        
        If the Team ID is omitted the script will loop through all teams in the database.

## Contributing

Contributions are welcome, feel free to create pull requests. For ideas or questions please
visit our Discord server at https://discord.gg/86eUAFz.
