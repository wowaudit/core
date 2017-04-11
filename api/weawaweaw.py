import patreon
from flask import request
...

client_id = "e87f60920a31e73647be0ea053f0ff3160a928d7c451e9d2799fa8f642950534"      # Replace with your data
client_secret = "bb716e4be58daa03b49286e7845b35be4abb0257f683429317f7e7e5d13bd1a6"  # Replace with your data
creator_id = "auditspreadsheet"     # Replace with your data

@app.route('/oauth/redirect')
def oauth_redirect():
    oauth_client = patreon.OAuth(client_id, client_secret)
    tokens = oauth_client.get_tokens(request.args.get('code'), '/oauth/redirect')
    access_token = tokens['access_token']

    api_client = patreon.API(access_token)
    user_response = api_client.fetch_user()
    user = user_response['data']
    included = user_response.get('included')
    if included:
        pledge = next((obj for obj in included
            if obj['type'] == 'pledge' and obj['relationships']['creator']['data']['id'] == creator_id), None)
        campaign = next((obj for obj in included
            if obj['type'] == 'campaign' and obj['relationships']['creator']['data']['id'] == creator_id), None)
    else:
        pledge = None
        campaign = None

    # pass user, pledge, and campaign to your view to render as needed
