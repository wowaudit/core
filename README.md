# World of Warcraft Audit
This is the back-end scraper engine that generates JSON files for the World of Warcraft Audit Spreadsheet,
found at https://wowaudit.com. The code is open-source and while it's possible for you to play around with,
it's not built with individual use in mind. Therefore, setting up the scripts can be difficult.

## Getting Started

1. Install dependencies (provided Ruby and Bundler are installed):

        $ bundle install

2. Enter the various credentials (and remove `template` from the file names):

        Enter your SQL and Redis credentials in `config/database.yml`

        In `config/keys.yml`:
        $ wcl_client_id: <your Warcraft Logs API key>

        The generated JSON files will be uploaded to a S3 server that you configure, so they can be
        easily fetched by the spreadsheet. In `config/storage.yml` you can enter your S3 credentials.

3. Initialise the database and add your API key to the table storing them:

        $ rake db:schema:load

4. Run the script locally:

        First, add a guild, team and characters to the database. Currently this
        has to be done manually. Then, run:
        $ bundle exec ruby bin/refresh_ids.rb <TEAM_ID> blizzard

        To add Warcraft Logs and Raider.io data to your team, the following scripts
        can be run in the same way as refresh_bnet_local:
        $ bundle exec ruby bin/refresh_ids.rb <TEAM_ID> wcl
        $ bundle exec ruby bin/refresh_ids.rb <TEAM_ID> raiderio

        If the Team ID is omitted the script will loop through all teams in the database.

## Contributing

Contributions are welcome, feel free to create pull requests. For ideas or questions please
visit our Discord server at https://discord.gg/86eUAFz.
